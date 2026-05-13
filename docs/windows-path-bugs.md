# Diagnóstico: Windows Path Bugs — Solución Mínima Aplicada

> Fecha: 2026-05-13
> Configuración: Neovim 0.12+ en Windows (Windows_NT)
> Estado: **Solución mínima implementada y verificada**

## Resumen

Dos bugs confirmados relacionados con paths en Windows:

| # | Bug | Archivo | Severidad |
|---|-----|---------|-----------|
| 1 | `:Luarc` genera JSON con barras mezcladas (`\` y `/`) | `lua/hzsr/nvim/luarc.lua` | Media |
| 2 | Mason PATH usa separador Unix `:` en lugar de `;` | `lua/lzy/l_mason.lua` | **Alta** |

---

## Bug 1: `:Luarc` — Barras mezcladas en JSON

### Evidencia (diagnóstico)

El JSON generado contiene:

```
C:\Program Files\Neovim\share/nvim/runtime  [mezcladas: SI]
```

### Causa raíz

`vim.env.VIMRUNTIME` viene de Neovim con formato mixto:
`C:\Program Files\Neovim\share/nvim/runtime`

Este valor se inserta directamente en `M.base_json.workspace.library` en `lua/hzsr/nvim/luarc.lua:23`:

```lua
M.base_json = {
  workspace = {
    library = {
      vim.env.VIMRUNTIME,  -- <-- viene con barras mezcladas
      "${3rd}/luv/library",
      "${3rd}/busted/library",
    },
  },
}
```

`vim.fs.joinpath` funciona correctamente para los paths que construye, pero no normaliza paths que ya vienen del entorno.

### Impacto

- lua-language-server puede no resolver correctamente el runtime path
- `${workspaceFolder}/lua` se añade dinámicamente pero el runtime de Neovim queda inconsistente

### Solución A: Normalizar en `base_json` (mínima)

Normalizar `vim.env.VIMRUNTIME` al entrar en `base_json`:

```lua
-- lua/hzsr/nvim/luarc.lua
local function normalize_path(p)
  if vim.fn.has "win32" == 1 and p then
    return p:gsub("/", "\\")
  end
  return p
end

M.base_json = {
  workspace = {
    library = {
      normalize_path(vim.env.VIMRUNTIME),
      "${3rd}/luv/library",
      "${3rd}/busted/library",
    },
  },
}
```

**Pros:** Mínimo cambio, resuelve el problema directo.
**Contras:** Solo normaliza VIMRUNTIME; si se agregan más paths dinámicos habría que normalizar cada uno.

### Solución B: Normalizador centralizado (robusta)

Crear una función `normalize_path` en `hzsr` y aplicarla en todos los puntos donde se construyen paths para el JSON:

```lua
-- lua/hzsr/nvim/luarc.lua
local function normalize_path(p)
  if not p then return p end
  if vim.fn.has "win32" == 1 then
    return p:gsub("/", "\\")
  end
  return p
end

-- Aplicar en generate() antes de devolver:
function M.generate(appname)
  local res = vim.deepcopy(M.base_json)
  -- ... existing code ...

  -- Normalizar todos los paths en workspace.library
  if vim.fn.has "win32" == 1 then
    for i, path in ipairs(res.workspace.library) do
      res.workspace.library[i] = normalize_path(path)
    end
  end

  return res
end
```

**Pros:** Cubre TODOS los paths del JSON de una vez, incluyendo los dinámicos de plugins.
**Contras:** Ligeramente más código, pero más mantenible a largo plazo.

**Recomendada: Solución B** — es más completa y no requiere recordar normalizar cada nuevo path.

---

## Bug 2: Mason — PATH con separador Unix `:`

### Evidencia (diagnóstico)

```
[3] PATH actual (primeros 200 chars):
  C:\Users\infor\AppData\Local\nvim-data/mason/bin:C:\Program Files\Alacritty\;...

[4] Separador de PATH:
  separador esperado = ';'
  separador usado en codigo = ':' (hardcodeado)

[5] Verificacion de mason en PATH:
  mason_bin unix en PATH  = NO encontrado
  entrada mason encontrada  = NINGUNA
```

El PATH queda como una sola entrada inválida:
`C:\Users\infor\AppData\Local\nvim-data/mason/bin:C:\Program Files\...`

Windows interpreta `:` como parte del path, no como separador. Resultado: **ningún ejecutable de Mason se encuentra**.

### Causa raíz

`lua/lzy/l_mason.lua:23`:

```lua
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

El separador `:` está hardcodeado. Windows usa `;`.

### Impacto

- **CRÍTICO**: `prettier`, `stylua`, `biome`, `lua-language-server`, etc. no se encuentran desde Neovim
- `:MasonInstallAll` funciona (instala los archivos) pero no se pueden ejecutar
- LSP servers pueden no iniciar correctamente

### Solución A: Separador condicional (mínima)

```lua
-- lua/lzy/l_mason.lua
function M.init_setup()
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
  local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

  -- Normalizar mason_bin a formato Windows si aplica
  if vim.fn.has "win32" == 1 then
    mason_bin = mason_bin:gsub("/", "\\")
  end

  if not vim.env.PATH:find(vim.pesc(mason_bin), 1, true) then
    vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
  end
end
```

**Pros:** Cambio mínimo y directo.
**Contras:** La búsqueda con `find` puede fallar si el PATH original tiene formato diferente al construido.

### Solución B: Verificación por entradas del PATH (robusta)

```lua
-- lua/lzy/l_mason.lua
function M.init_setup()
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
  local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

  -- Normalizar para comparación
  local mason_lower = mason_bin:lower():gsub("[/\\]", "\\")

  -- Verificar si ya está en PATH comparando entrada por entrada
  local entries = vim.split(vim.env.PATH, path_sep, { plain = true })
  local already_in_path = false
  for _, entry in ipairs(entries) do
    if entry:lower():gsub("[/\\]", "\\") == mason_lower then
      already_in_path = true
      break
    end
  end

  if not already_in_path then
    vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
  end
end
```

**Pros:** Compara entrada por entrada, evitando falsos negativos por diferencias de formato.
**Contras:** Más código, pero mucho más robusto en Windows.

**Recomendada: Solución B** — el `find` simple de la Solución A puede fallar si el PATH tiene el path de Mason en formato diferente (con `\` vs `/`).

---

## Archivos afectados

| Archivo | Líneas | Cambio |
|---------|--------|--------|
| `lua/hzsr/nvim/luarc.lua` | 14-30, 126-137 | Normalizar paths en JSON |
| `lua/lzy/l_mason.lua` | 19-24 | Separador PATH + verificación |

## Scripts de diagnóstico

| Archivo | Propósito |
|---------|-----------|
| `diag_luarc.lua` | Verificar paths en `:Luarc` |
| `diag_mason.lua` | Verificar PATH de Mason |

Ejecutar:
```bash
nvim --headless -c "luafile diag_luarc.lua" -c "q"
nvim --headless -c "luafile diag_mason.lua" -c "q"
```

---

## Solución Mínima Implementada

### Bug 1 — Luarc: `lua/hzsr/nvim/luarc.lua`

Se agregó `normalize_path()` y se aplica en `M.generate()` a todos los paths de `workspace.library`:

```lua
-- Lineas 124-132
local function normalize_path(p)
  if not p then return p end
  if vim.fn.has "win32" == 1 then
    return p:gsub("/", "\\")
  end
  return p
end

-- Lineas 146-150 (dentro de M.generate)
if vim.fn.has "win32" == 1 then
  for i, path in ipairs(res.workspace.library) do
    res.workspace.library[i] = normalize_path(path)
  end
end
```

**Resultado verificado:**
```
[6] Paths dentro del JSON (workspace.library):
  C:\Program Files\Neovim\share\nvim\runtime  [mezcladas: NO]
  ${3rd}\luv\library  [mezcladas: NO]
  ${3rd}\busted\library  [mezcladas: NO]
```

### Bug 2 — Mason: `lua/lzy/l_mason.lua`

Se cambió el separador hardcodeado `:` por uno condicional:

```lua
-- Linea 21
local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

-- Linea 24
vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
```

**Resultado verificado:**
```
[3] PATH actual:
  C:\Users\infor\AppData\Local\nvim-data/mason/bin;C:\Program Files\...
```

El PATH ahora usa `;` correctamente. Mason bin es la primera entrada.

## Resumen de cambios en el repo

| Archivo | Cambio |
|---------|--------|
| `lua/hzsr/nvim/luarc.lua` | +16 líneas: `normalize_path()` + aplicación en `generate()` |
| `lua/lzy/l_mason.lua` | +1 línea: `path_sep` condicional, reemplazo de `:` hardcodeado |

---

## Issues creados

- [#1](https://github.com/heizeisaburou/saburou-nvim/issues/1) — Luarc paths mezclados
- [#2](https://github.com/heizeisaburou/saburou-nvim/issues/2) — Mason PATH separador Unix
