-- lzy/l_mason

local M = {}

M.opts = {
  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },

  max_concurrent_installers = 10,
}

function M.init_setup()
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
  local path_sep = vim.fn.has "win32" == 1 and ";" or ":"

  local already_in_path = false
  if vim.fn.has "win32" == 1 then
    local mason_normalized = mason_bin:lower():gsub("[/\\]", "\\")
    local entries = vim.split(vim.env.PATH, path_sep, { plain = true })
    for _, entry in ipairs(entries) do
      if entry:lower():gsub("[/\\]", "\\") == mason_normalized then
        already_in_path = true
        break
      end
    end
  else
    if vim.env.PATH:find(vim.pesc(mason_bin), 1, true) then
      already_in_path = true
    end
  end

  if not already_in_path then
    vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
  end

  vim.api.nvim_create_user_command("MasonInstallAll", function()
    -- Carga mason.nvim si sigue lazy.
    local ok_lazy, lazy = pcall(require, "lazy")
    if ok_lazy then
      lazy.load { plugins = { "mason.nvim" } }
    end

    require("hzsr.mason").install_all()
  end, {})
end

function M.setup()
  ---@diagnostic disable-next-line
  require("mason").setup(M.opts)
end

return M
