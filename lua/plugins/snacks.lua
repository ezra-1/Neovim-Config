local M = {
  "folke/snacks.nvim",
  event = "VimEnter",
}

function M.config()
  local snacks = require("snacks")
  local icons = require("plugins.icons")
  local wk = require("which-key")

  ---------------------------------------------------------------------------
  -- 🧩 Setup
  ---------------------------------------------------------------------------
  snacks.setup({
    ---------------------------------------------------------------------------
    -- 🪄 Input
    ---------------------------------------------------------------------------
    input = {
      enabled = true,
      default_prompt = "Input:",
      title_pos = "left",
      insert_only = true,
      start_in_insert = true,
      border = "rounded",
      relative = "cursor",
      prefer_width = 40,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
      win_options = {
        winblend = 10,
        wrap = false,
        list = true,
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },
    },

    ---------------------------------------------------------------------------
    -- 🔍 Select
    ---------------------------------------------------------------------------
    select = {
      enabled = true,
      backend = { "nui", "telescope", "fzf_lua", "fzf", "builtin" },
      trim_prompt = true,
      nui = {
        position = "50%",
        relative = "editor",
        border = { style = "rounded" },
        buf_options = { swapfile = false, filetype = "SnacksSelect" },
        win_options = { winblend = 10 },
        max_width = 80,
        max_height = 40,
        min_width = 40,
        min_height = 10,
      },
      builtin = {
        border = "rounded",
        relative = "editor",
        win_options = {
          winblend = 10,
          cursorline = true,
          cursorlineopt = "both",
        },
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        max_height = 0.9,
        min_height = { 10, 0.2 },
        mappings = {
          ["<Esc>"] = "Close",
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
        },
      },
    },

    ---------------------------------------------------------------------------
    -- 📁 Explorer
    ---------------------------------------------------------------------------
    explorer = {
      enabled = true,
      replace_netrw = true,
      auto_close = false,
      columns = { "icon", "size", "mtime" }, -- permissions removed (perf)
      diagnostics = { enable = true },
    },

    ---------------------------------------------------------------------------
    -- 🔔 Notifier
    ---------------------------------------------------------------------------
    notifier = {
      enabled = true,
      timeout = 3000,
      top_down = true,
      max_width = 80,
      background_color = "#000000", -- FIXED spelling
      icons = {
        error = " ",
        warn  = " ",
        info  = " ",
        debug = " ",
        trace = "✎ ",
      },
    },

    ---------------------------------------------------------------------------
    -- 🧘 Zen
    ---------------------------------------------------------------------------
    zen = {
      enabled = true,
      toggles = {
        ufo             = true,
        dim             = true,
        diagnostics     = false,
        line_number     = false,
        relative_number = false,
        signcolumn      = "no",
      },
      window = {
        backdrop = 0.95,
        width = 0.9,
        height = 0.9,
      },
    },

    ---------------------------------------------------------------------------
    -- 🌀 LazyGit
    ---------------------------------------------------------------------------
    lazygit = {
      enabled = true,
      win = {
        border = "rounded",
        relative = "editor",
        width = 0.9,
        height = 0.9,
        style = "minimal",
        zindex = 50,
        winblend = 15,
      },
    },

    ---------------------------------------------------------------------------
    -- 🧠 Terminal
    ---------------------------------------------------------------------------
    terminal = {
      enabled = true,
      float = {
        border = "rounded",
        width = 0.9,
        height = 0.9,
        winblend = 15,
        style = "minimal",
      },
      start_in_insert = true,
      shell = vim.o.shell,
    },

    ---------------------------------------------------------------------------
    -- 🏁 Dashboard
    ---------------------------------------------------------------------------
    dashboard = {
      enabled = true,
      header = {
        [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      center = {
        { icon = icons.ui.Files,   desc = " Find File",    key = "f", action = "Telescope find_files" },
        { icon = icons.ui.NewFile, desc = " New File",     key = "n", action = "ene | startinsert" },
        { icon = icons.ui.History, desc = " Recent Files", key = "r", action = "Telescope oldfiles" },
        { icon = icons.ui.Text,    desc = " Find Text",    key = "t", action = "Telescope live_grep" },
        { icon = icons.ui.SignOut, desc = " Quit",         key = "q", action = "qa" },
      },
      footer = { "Loading plugins..." },
      opts = { border = "rounded", width = 60 },
    },
  })

  ---------------------------------------------------------------------------
  -- ⚡ Dashboard footer update (FIXED event)
  ---------------------------------------------------------------------------
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
      local stats = require("lazy").stats()
      snacks.dashboard.config.footer = {
        ("⚡ Loaded %d plugins in %.2fms"):format(stats.count, stats.startuptime),
      }
      vim.cmd.redraw()
    end,
  })

  ---------------------------------------------------------------------------
  -- 📉 Statusline handling (SAFE)
  ---------------------------------------------------------------------------
  vim.api.nvim_create_autocmd("User", {
    pattern = "SnacksDashboardReady",
    callback = function()
      vim.o.laststatus = 0
      vim.api.nvim_create_autocmd("BufLeave", {
        once = true,
        callback = function()
          vim.o.laststatus = 3
        end,
      })
    end,
  })

  ---------------------------------------------------------------------------
  -- 🧩 UFO Toggle (FIXED)
  ---------------------------------------------------------------------------
  snacks.toggle.new({
    id = "ufo",
    name = "UFO Folds",
    get = function()
      return vim.o.foldenable
    end,
    set = function(state)
      vim.o.foldenable = state
      vim.o.foldcolumn = state and "1" or "0"
      if state then
        require("ufo").enable()
      else
        require("ufo").disable()
      end
    end,
  })

  ---------------------------------------------------------------------------
  -- 🔑 Keymaps
  ---------------------------------------------------------------------------
  wk.add({
    { "<leader>e",  function() snacks.explorer.open() end, desc = "Explorer" },
    { "<leader>z",  function() snacks.zen.zen() end, desc = "Zen Mode" },
    { "<leader>n",  function() snacks.notifier.show_history() end, desc = "Notifications" },
    { "<leader>gj", function() snacks.lazygit.open() end, desc = "LazyGit" },
    { "<leader>;",  function() snacks.terminal.toggle() end, desc = "Terminal" },
  })
end

return M

