## Descripcion

El comando `:Luarc` genera un archivo `.luarc.json` con paths que mezclan barras de Windows (`\`) y Unix (`/`), lo que puede causar que lua-language-server no resuelva correctamente los paths.

## Evidencia

Al ejecutar el diagnostico en Windows:

```
[6] Paths dentro del JSON (workspace.library):
  C:\Program Files\Neovim\share/nvim/runtime  [mezcladas: SI]
```

`vim.env.VIMRUNTIME` viene de Neovim con formato mixto (`C:\Program Files\Neovim\share/nvim/runtime`) y se inserta directamente en el JSON sin normalizacion.

## Causa raiz

`lua/hzsr/nvim/luarc.lua:23`: `vim.env.VIMRUNTIME` se usa tal cual sin normalizar las barras en Windows.

## Solucion propuesta

Agregar un normalizador de paths que se aplique a todos los entries de `workspace.library` en la funcion `generate()`:

```lua
local function normalize_path(p)
  if not p then return p end
  if vim.fn.has "win32" == 1 then
    return p:gsub("/", "\\")
  end
  return p
end

-- En M.generate(), antes de devolver:
if vim.fn.has "win32" == 1 then
  for i, path in ipairs(res.workspace.library) do
    res.workspace.library[i] = normalize_path(path)
  end
end
```

## Archivos afectados

- `lua/hzsr/nvim/luarc.lua`

## Script de diagnostico

`diag_luarc.lua` — ejecutar con:
```bash
nvim --headless -c "luafile diag_luarc.lua" -c "q"
```

## Labels

`bug`, `windows`
