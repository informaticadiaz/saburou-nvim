## Descripcion

Los ejecutables de Mason (prettier, stylua, biome, lua-language-server, etc.) no se encuentran desde Neovim en Windows a pesar de estar instalados correctamente.

## Estado

- [x] **Solucion minima implementada** — PR en rama `bug-windows-paths-luarc-mason`
- [x] **Verificado** — PATH usa separador `;` correctamente en Windows
- [ ] **Solucion robusta pendiente** — verificacion entrada por entrada (ver abajo)

## Evidencia (antes del fix)

```
[3] PATH actual:
  C:\Users\infor\AppData\Local\nvim-data/mason/bin:C:\Program Files\Alacritty\;...

[4] Separador de PATH:
  separador esperado = ';'
  separador usado en codigo = ':' (hardcodeado)
```

## Causa raiz

`lua/lzy/l_mason.lua:23`: separador `:` hardcodeado. Windows usa `;`.

## Solucion minima aplicada

Se reemplazo `:` por un separador condicional:

```lua
local path_sep = vim.fn.has "win32" == 1 and ";" or ":"
vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
```

## Resultado verificado (despues del fix)

```
[3] PATH actual:
  C:\Users\infor\AppData\Local\nvim-data/mason/bin;C:\Program Files\...
```

## Mejora futura (Solucion B — robusta)

La solucion minima usa `find()` para verificar si mason_bin ya esta en PATH. Esto puede fallar si el PATH tiene el path en formato diferente (`\` vs `/`).

**Solucion pendiente:** verificar entrada por entrada normalizando ambas rutas:

```lua
local mason_lower = mason_bin:lower():gsub("[/\\]", "\\")
local entries = vim.split(vim.env.PATH, path_sep, { plain = true })
local already_in_path = false
for _, entry in ipairs(entries) do
  if entry:lower():gsub("[/\\]", "\\") == mason_lower then
    already_in_path = true
    break
  end
end
```

Esto evita falsos negativos cuando el PATH del sistema tiene `C:\...\mason\bin` y el codigo construye `C:\...\mason/bin`.

## Impacto original

- **CRITICO**: ejecutables de Mason no se encontraban desde Neovim
- LSP servers podian no iniciar correctamente

## Archivos afectados

- `lua/lzy/l_mason.lua`

## Script de diagnostico

`diag_mason.lua` — ejecutar con:
```bash
nvim --headless -c "luafile diag_mason.lua" -c "q"
```
