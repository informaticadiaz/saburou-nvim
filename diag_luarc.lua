-- diag_luarc.lua
-- Ejecutar: nvim --headless -c "luafile diag_luarc.lua" -c "q"

local function sep()
  print(string.rep("-", 70))
end

sep()
print("DIAGNOSTICO: :Luarc — paths en Windows")
sep()

-- 1. stdpath values
print("\n[1] vim.fn.stdpath valores:")
print(string.format("  config  = %s", vim.fn.stdpath "config"))
print(string.format("  data    = %s", vim.fn.stdpath "data"))
print(string.format("  state   = %s", vim.fn.stdpath "state"))

-- 2. dirname + joinpath behavior
print("\n[2] vim.fs.dirname(vim.fn.stdpath 'config'):")
local config_parent = vim.fs.dirname(vim.fn.stdpath "config")
print(string.format("  parent  = %s", config_parent))

print("\n[3] vim.fs.joinpath resultados:")
local joined = vim.fs.joinpath(config_parent, "nvim")
print(string.format("  joinpath(parent, 'nvim') = %s", joined))

-- 3. configdir completo
print("\n[4] hzsr.nvim.configdir():")
local ok, hzsr = pcall(require, "hzsr")
if ok then
  local cfg = hzsr.nvim.configdir()
  print(string.format("  configdir = %s", cfg))

  local luarc_path = hzsr.nvim.luarc.config_path()
  print(string.format("  luarc path = %s", luarc_path))

  -- Verificar si hay barras mezcladas
  local has_mixed = luarc_path:match("\\") and luarc_path:match("/")
  print(string.format("  barras mezcladas (\\ y /) = %s", has_mixed and "SI — BUG" or "NO"))

  -- Verificar contenido generado
  print("\n[5] JSON generado (primeras lineas):")
  local json = hzsr.nvim.luarc.encode()
  local lines = vim.split(json, "\n", { plain = true })
  for i = 1, math.min(10, #lines) do
    print(string.format("  %s", lines[i]))
  end

  -- Verificar paths dentro del JSON
  print("\n[6] Paths dentro del JSON (workspace.library):")
  local parsed = vim.json.decode(json)
  if parsed and parsed.workspace and parsed.workspace.library then
    for _, p in ipairs(parsed.workspace.library) do
      local mixed = p:match("\\") and p:match("/")
      print(string.format("  %s  [mezcladas: %s]", p, mixed and "SI" or "NO"))
    end
  end
else
  print("  ERROR: no se pudo cargar hzsr")
end

sep()
print("FIN DIAGNOSTICO Luarc")
sep()
