## Descripcion

Los ejecutables de Mason (prettier, stylua, biome, lua-language-server, etc.) no se encuentran desde Neovim en Windows a pesar de estar instalados correctamente.

## Evidencia

Al ejecutar el diagnostico en Windows:

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

El PATH queda como una sola entrada invalida porque Windows interpreta `:` como parte del path, no como separador. Resultado: **ningun ejecutable de Mason se encuentra**.

## Causa raiz

`lua/lzy/l_mason.lua:23`:

```lua
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

El separador `:` esta hardcodeado. Windows usa `;`.

## Impacto

- **CRITICO**: `prettier`, `stylua`, `biome`, `lua-language-server`, etc. no se encuentran desde Neovim
- `:MasonInstallAll` funciona (instala los archivos) pero no se pueden ejecutar
- LSP servers pueden no iniciar correctamente

## Solucion propuesta

Usar el separador correcto segun la plataforma y verificar entrada por entrada:

```lua
function M.init_setup()
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
  local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

  -- Normalizar para comparacion
  local mason_lower = mason_bin:lower():gsub("[/\\]", "\\")

  -- Verificar si ya esta en PATH comparando entrada por entrada
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

## Archivos afectados

- `lua/lzy/l_mason.lua`

## Script de diagnostico

`diag_mason.lua` — ejecutar con:
```bash
nvim --headless -c "luafile diag_mason.lua" -c "q"
```

## Labels

`bug`, `windows`, `critical`
