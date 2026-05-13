-- diag_mason.lua
-- Ejecutar: nvim --headless -c "luafile diag_mason.lua" -c "q"

local function sep()
  print(string.rep("-", 70))
end

sep()
print("DIAGNOSTICO: Mason — PATH en Windows")
sep()

-- 1. Detectar plataforma
print("\n[1] Plataforma:")
print(string.format("  vim.loop.os_uname().sysname = %s", vim.loop.os_uname().sysname))
print(string.format("  jit.os = %s", jit and jit.os or "N/A"))

-- 2. Mason bin path
print("\n[2] Mason bin path construido:")
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
print(string.format("  con '/mason/bin'      = %s", mason_bin))

local mason_bin_correct = vim.fn.stdpath "data" .. vim.fn.has "win32" == 1 and "\\mason\\bin" or "/mason/bin"
print(string.format("  con separador correcto = %s", mason_bin_correct))

-- 3. PATH actual
print("\n[3] PATH actual (primeros 200 chars):")
print(string.format("  %s", vim.env.PATH:sub(1, 200)))

-- 4. Separador de PATH
print("\n[4] Separador de PATH:")
local path_sep = vim.fn.has "win32" == 1 and ";" or ":"
print(string.format("  separador esperado = '%s'", path_sep))
print(string.format("  separador usado en codigo = ':' (hardcodeado)"))

-- 5. Verificar si mason_bin esta en PATH
print("\n[5] Verificacion de mason en PATH:")
local found_unix = vim.env.PATH:find(vim.pesc(mason_bin), 1, true)
print(string.format("  mason_bin unix en PATH  = %s", found_unix and "ENCONTRADO" or "NO encontrado"))

-- Buscar con separador correcto
local entries = vim.split(vim.env.PATH, path_sep, { plain = true })
local found_correct = false
for _, entry in ipairs(entries) do
  if entry:lower():find("mason.bin", 1, true) or entry:lower():find("mason\\bin", 1, true) then
    print(string.format("  entrada mason encontrada  = %s", entry))
    found_correct = true
  end
end
if not found_correct then
  print("  entrada mason encontrada  = NINGUNA")
end

-- 6. Verificar si el directorio mason/bin existe fisicamente
print("\n[6] Existencia fisica del directorio:")
local data_path = vim.fn.stdpath "data"
print(string.format("  data path = %s", data_path))

local win_mason = data_path .. "\\mason\\bin"
local unix_mason = data_path .. "/mason/bin"

local win_stat = vim.uv.fs_stat(win_mason)
local unix_stat = vim.uv.fs_stat(unix_mason)

print(string.format("  existe '%s' = %s", win_mason, win_stat and "SI" or "NO"))
print(string.format("  existe '%s' = %s", unix_mason, unix_stat and "SI" or "NO"))

-- 7. Listar ejecutables en mason/bin
print("\n[7] Contenidos de mason/bin:")
local actual_dir = win_stat and win_mason or (unix_stat and unix_mason or nil)
if actual_dir then
  local handle = vim.uv.fs_scandir(actual_dir)
  if handle then
    local count = 0
    while true do
      local name = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if count < 15 then
        print(string.format("  %s", name))
      end
      count = count + 1
    end
    if count > 15 then
      print(string.format("  ... y %d mas", count - 15))
    end
  else
    print("  ERROR: no se pudo escanear el directorio")
  end
else
  print("  DIRECTORIO NO EXISTE — Mason no esta instalado")
end

-- 8. Verificar prettier especificamente
print("\n[8] Busqueda de prettier:")
if actual_dir then
  local prettier_win = actual_dir .. "\\prettier.cmd"
  local prettier_unix = actual_dir .. "/prettier"
  local pstat1 = vim.uv.fs_stat(prettier_win)
  local pstat2 = vim.uv.fs_stat(prettier_unix)
  print(string.format("  '%s' = %s", prettier_win, pstat1 and "EXISTS" or "NO"))
  print(string.format("  '%s' = %s", prettier_unix, pstat2 and "EXISTS" or "NO"))
end

sep()
print("FIN DIAGNOSTICO Mason")
sep()
