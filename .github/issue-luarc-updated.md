## Descripcion

El comando `:Luarc` genera un archivo `.luarc.json` con paths que mezclan barras de Windows (`\`) y Unix (`/`), lo que puede causar que lua-language-server no resuelva correctamente los paths.

## Estado

- [x] **Solucion minima implementada** — PR en rama `bug-windows-paths-luarc-mason`
- [x] **Verificado** — paths normalizados correctamente en Windows

## Evidencia (antes del fix)

```
[6] Paths dentro del JSON (workspace.library):
  C:\Program Files\Neovim\share/nvim/runtime  [mezcladas: SI]
```

## Causa raiz

`lua/hzsr/nvim/luarc.lua:23`: `vim.env.VIMRUNTIME` viene con formato mixto y se inserta sin normalizar.

## Solucion aplicada

Se agrego `normalize_path()` en `M.generate()` que normaliza TODOS los paths de `workspace.library` en Windows:

```lua
local function normalize_path(p)
  if not p then return p end
  if vim.fn.has "win32" == 1 then
    return p:gsub("/", "\\")
  end
  return p
end

-- En M.generate():
if vim.fn.has "win32" == 1 then
  for i, path in ipairs(res.workspace.library) do
    res.workspace.library[i] = normalize_path(path)
  end
end
```

## Resultado verificado (despues del fix)

```
[6] Paths dentro del JSON (workspace.library):
  C:\Program Files\Neovim\share\nvim\runtime  [mezcladas: NO]
  ${3rd}\luv\library  [mezcladas: NO]
  ${3rd}\busted\library  [mezcladas: NO]
```

## Mejora futura (Solucion B — robusta)

La solucion actual ya normaliza todos los paths en `generate()`, que era la Solucion B propuesta. No queda trabajo pendiente para este bug.

Si en el futuro se agregan nuevas fuentes de paths al JSON, bastara con que pasen por `generate()` para ser normalizados automaticamente.

## Archivos afectados

- `lua/hzsr/nvim/luarc.lua`

## Script de diagnostico

`diag_luarc.lua` — ejecutar con:
```bash
nvim --headless -c "luafile diag_luarc.lua" -c "q"
```
