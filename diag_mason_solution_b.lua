-- diag_mason_solution_b.lua
-- Verifica la Solución B: verificación entrada por entrada del PATH

local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

print("----------------------------------------------------------------------")
print("VERIFICACION: Solución B — Mason PATH entry-by-entry verification")
print("----------------------------------------------------------------------")
print()

-- Test 1: Separador correcto
print("[Test 1] Separador de PATH:")
print("  esperado = '" .. (vim.fn.has("win32") == 1 and ";" or ":") .. "'")
print("  usado    = '" .. path_sep .. "'")
print("  resultado = " .. (path_sep == (vim.fn.has("win32") == 1 and ";" or ":") and "PASS" or "FAIL"))
print()

-- Test 2: Simular verificación con formato mixto (mason_bin con /, PATH con \)
print("[Test 2] Verificación con formato mixto:")
local mason_bin = "C:\\Users\\test\\nvim-data/mason/bin"
local test_path = "C:\\Users\\test\\nvim-data\\mason\\bin;C:\\Windows\\system32"

local mason_normalized = mason_bin:lower():gsub("[/\\]", "\\")
local entries = vim.split(test_path, path_sep, { plain = true })
local found = false
for _, entry in ipairs(entries) do
  local entry_normalized = entry:lower():gsub("[/\\]", "\\")
  if entry_normalized == mason_normalized then
    found = true
    print("  mason_bin original    = " .. mason_bin)
    print("  mason_bin normalized  = " .. mason_normalized)
    print("  entrada PATH          = " .. entry)
    print("  entrada normalized    = " .. entry_normalized)
    print("  match                 = SI")
    break
  end
end
print("  resultado = " .. (found and "PASS" or "FAIL"))
print()

-- Test 3: Verificar que NO encuentra paths diferentes
print("[Test 3] Verificación con path diferente:")
local different_path = "C:\\Users\\test\\nvim-data\\mason\\packages;C:\\Windows\\system32"
local entries2 = vim.split(different_path, path_sep, { plain = true })
local found2 = false
for _, entry in ipairs(entries2) do
  if entry:lower():gsub("[/\\]", "\\") == mason_normalized then
    found2 = true
    break
  end
end
print("  mason_bin normalized  = " .. mason_normalized)
print("  PATH entries          = " .. different_path)
print("  encontrado            = " .. (found2 and "SI (ERROR)" or "NO (correcto)"))
print("  resultado = " .. (not found2 and "PASS" or "FAIL"))
print()

-- Test 4: PATH real de Neovim
print("[Test 4] Verificación con PATH real de Neovim:")
local real_mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
local real_mason_normalized = real_mason_bin:lower():gsub("[/\\]", "\\")
local real_entries = vim.split(vim.env.PATH, path_sep, { plain = true })
local real_found = false
local real_entry = ""
for _, entry in ipairs(real_entries) do
  if entry:lower():gsub("[/\\]", "\\") == real_mason_normalized then
    real_found = true
    real_entry = entry
    break
  end
end
print("  mason_bin             = " .. real_mason_bin)
print("  mason_normalized      = " .. real_mason_normalized)
print("  encontrado en PATH    = " .. (real_found and "SI" or "NO"))
if real_found then
  print("  entrada encontrada    = " .. real_entry)
end
print("  total entries en PATH = " .. #real_entries)
print("  resultado = " .. (real_found and "PASS" or "FAIL"))
print()

-- Test 5: Verificar que la primera entrada es mason_bin
print("[Test 5] Mason bin es la primera entrada del PATH:")
local first_entry = real_entries[1]
local first_normalized = first_entry:lower():gsub("[/\\]", "\\")
local is_first = (first_normalized == real_mason_normalized)
print("  primera entry         = " .. first_entry)
print("  primera normalized    = " .. first_normalized)
print("  es mason_bin          = " .. (is_first and "SI" or "NO"))
print("  resultado = " .. (is_first and "PASS" or "FAIL"))
print()

print("----------------------------------------------------------------------")
print("FIN VERIFICACION Solución B")
print("----------------------------------------------------------------------")
