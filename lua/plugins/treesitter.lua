local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- MUST be loaded eagerly
  build = ":TSUpdate",
}

function M.config()
  require 'nvim-treesitter'.install { "css", "gitignore", "html", "javascript", "tsx" }
end

return M
