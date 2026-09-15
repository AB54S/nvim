-- ============================================================================
-- NEOVIM CONFIG — LazyVim aesthetic, single file, no LazyVim framework
-- ============================================================================

-- ============================================================================
-- LEADER (must be set before lazy loads plugins)
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ============================================================================
-- BOOTSTRAP LAZY.NVIM
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================

require("lazy").setup({

  -- --------------------------------------------------------------------------
  -- COLORSCHEME (load first, high priority)
  -- --------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      integrations = {
        bufferline = true,
        cmp = true,
        gitsigns = true,
        neotree = true,
        noice = true,
        notify = true,
        treesitter = true,
        which_key = true,
        lsp_trouble = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- --------------------------------------------------------------------------
  -- SNACKS (load first, high priority — many plugins depend on it)
  -- --------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile    = { enabled = true },
      dashboard  = {
        enabled = true,
        preset = {
          header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = " ", key = "f", desc = "Find File",    action = function() Snacks.picker.files() end },
            { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text",    action = function() Snacks.picker.grep() end },
            { icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
            { icon = " ", key = "c", desc = "Config",       action = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end },
            { icon = "󰒲 ", key = "l", desc = "Lazy",         action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",          action = ":qa" },
          },
        },
      },
      explorer    = { enabled = true },
      indent      = { enabled = true },
      input       = { enabled = true },
      notifier    = { enabled = true, timeout = 3000 },
      picker      = { enabled = true },
      quickfile   = { enabled = true },
      scope       = { enabled = true },
      scroll      = { enabled = true },
      statuscolumn = { enabled = true },
      terminal    = { enabled = true },
      words       = { enabled = true },
      zen         = { enabled = true },
      styles = {
        notification = {},
      },
    },
    keys = {
      -- Top pickers
      { "<leader><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,            desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n",       function() Snacks.picker.notifications() end,   desc = "Notification History" },
      -- File explorer
      { "<leader>e",       function() Snacks.explorer() end,               desc = "File Explorer" },
      -- Find
      { "<leader>ff",      function() Snacks.picker.files() end,           desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,       desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,          desc = "Recent" },
      { "<leader>fb",      function() Snacks.picker.buffers() end,         desc = "Buffers" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- Grep / search
      { "<leader>sg",      function() Snacks.picker.grep() end,            desc = "Grep" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,       desc = "Grep Word", mode = { "n", "x" } },
      { "<leader>sb",      function() Snacks.picker.lines() end,           desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,    desc = "Grep Open Buffers" },
      { '<leader>s"',      function() Snacks.picker.registers() end,       desc = "Registers" },
      { "<leader>sa",      function() Snacks.picker.autocmds() end,        desc = "Autocmds" },
      { "<leader>sc",      function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,        desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,     desc = "Diagnostics" },
      { "<leader>sh",      function() Snacks.picker.help() end,            desc = "Help Pages" },
      { "<leader>sH",      function() Snacks.picker.highlights() end,      desc = "Highlights" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,         desc = "Keymaps" },
      { "<leader>sm",      function() Snacks.picker.marks() end,           desc = "Marks" },
      { "<leader>sq",      function() Snacks.picker.qflist() end,          desc = "Quickfix List" },
      { "<leader>sR",      function() Snacks.picker.resume() end,          desc = "Resume" },
      { "<leader>su",      function() Snacks.picker.undo() end,            desc = "Undo History" },
      -- Git
      { "<leader>gb",      function() Snacks.picker.git_branches() end,    desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,         desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,      desc = "Git Status" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,    desc = "Git Log File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,              desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg",      function() Snacks.lazygit() end,                desc = "Lazygit" },
      -- LSP via picker
      { "gd",              function() Snacks.picker.lsp_definitions() end,     desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,    desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,      desc = "References", nowait = true },
      { "gI",              function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,         desc = "LSP Symbols" },
      -- Misc
      { "<leader>z",       function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,               desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,         desc = "Select Scratch Buffer" },
      { "<leader>bd",      function() Snacks.bufdelete() end,              desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,     desc = "Rename File" },
      { "<leader>un",      function() Snacks.notifier.hide() end,          desc = "Dismiss All Notifications" },
      { "<c-/>",           function() Snacks.terminal() end,               desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,               desc = "which_key_ignore" },
      { "]]",              function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference", mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Debug globals
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end

          -- Toggle mappings (set up after VeryLazy so Snacks is ready)
          Snacks.toggle.option("spell",          { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", {
            off = 0,
            on  = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
            name = "Conceal Level",
          }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- FILE EXPLORER — neo-tree
  -- --------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>fe", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
      { "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
      { "<leader>ge", function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end, desc = "Git Explorer" },
      { "<leader>be", function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end, desc = "Buffer Explorer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then return end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["l"]      = "open",
          ["h"]      = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              vim.fn.setreg("+", node:get_id(), "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders  = true,
          expander_collapsed = "",
          expander_expanded  = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged   = "󰱒",
          },
        },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- BUFFERLINE (tab bar)
  -- --------------------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<S-h>",        "<cmd>BufferLineCyclePrev<cr>",           desc = "Prev Buffer" },
      { "<S-l>",        "<cmd>BufferLineCycleNext<cr>",           desc = "Next Buffer" },
      { "[b",           "<cmd>BufferLineCyclePrev<cr>",           desc = "Prev Buffer" },
      { "]b",           "<cmd>BufferLineCycleNext<cr>",           desc = "Next Buffer" },
      { "[B",           "<cmd>BufferLineMovePrev<cr>",            desc = "Move Buffer Prev" },
      { "]B",           "<cmd>BufferLineMoveNext<cr>",            desc = "Move Buffer Next" },
      { "<leader>bp",   "<cmd>BufferLineTogglePin<cr>",           desc = "Toggle Pin" },
      { "<leader>bP",   "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br",   "<cmd>BufferLineCloseRight<cr>",          desc = "Delete Buffers to the Right" },
      { "<leader>bl",   "<cmd>BufferLineCloseLeft<cr>",           desc = "Delete Buffers to the Left" },
      { "<leader>bj",   "<cmd>BufferLinePick<cr>",                desc = "Pick Buffer" },
      { "<leader>bb",   "<cmd>e #<cr>",                           desc = "Switch to Other Buffer" },
      { "<leader>`",    "<cmd>e #<cr>",                           desc = "Switch to Other Buffer" },
      { "<leader>bD",   "<cmd>bd<cr>",                            desc = "Delete Buffer and Window" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { Error = " ", Warn = " ", Info = " ", Hint = "󰠠 " }
          local ret = (diag.error   and icons.Error .. diag.error   .. " " or "")
                   .. (diag.warning and icons.Warn  .. diag.warning        or "")
          return vim.trim(ret)
        end,
        offsets = {
          { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" },
          { filetype = "snacks_layout_box" },
        },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- LUALINE (status line)
  -- --------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰠠 " } },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename",  path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          -- Sidekick: Copilot LSP status
          {
            function()
              local status = require("sidekick.status").get()
              return status and " " or ""
            end,
            color = function()
              local ok, status = pcall(require("sidekick.status").get)
              if ok and status then
                return status.kind == "Error" and "DiagnosticError"
                    or status.busy and "DiagnosticWarn"
                    or "Special"
              end
            end,
            cond = function()
              local ok, status = pcall(require("sidekick.status").get)
              return ok and status ~= nil
            end,
          },
          -- Sidekick: active CLI session indicator
          {
            function()
              local ok, cli = pcall(require("sidekick.status").cli)
              if ok and #cli > 0 then
                return " " .. (#cli > 1 and #cli or "")
              end
              return ""
            end,
            cond = function()
              local ok, cli = pcall(require("sidekick.status").cli)
              return ok and #cli > 0
            end,
            color = "Special",
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if gs then return { added = gs.added, modified = gs.changed, removed = gs.removed } end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function() return " " .. os.date("%R") end,
        },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },

  -- --------------------------------------------------------------------------
  -- NOICE (fancy cmdline / messages UI)
  -- --------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>sn",  "",                                                       desc = "+noice" },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,              desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,           desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,               desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,           desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4)  then return "<c-f>" end end, silent = true, expr = true, mode = { "i", "n", "s" } },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, mode = { "i", "n", "s" } },
    },
  },

  -- --------------------------------------------------------------------------
  -- WHICH-KEY
  -- --------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>a",     group = "ai" },
          { "<leader>b",     group = "buffer" },
          { "<leader>c",     group = "code" },
          { "<leader>f",     group = "file/find" },
          { "<leader>g",     group = "git" },
          { "<leader>q",     group = "quit/session" },
          { "<leader>s",     group = "search" },
          { "<leader>sn",    group = "noice" },
          { "<leader>u",     group = "ui" },
          { "<leader>w",     group = "windows", proxy = "<c-w>" },
          { "<leader>x",     group = "diagnostics/quickfix" },
          { "[",             group = "prev" },
          { "]",             group = "next" },
          { "g",             group = "goto" },
          { "z",             group = "fold" },
        },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Keymaps (which-key)" },
    },
  },

  -- --------------------------------------------------------------------------
  -- GITSIGNS
  -- --------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buf, desc = desc, silent = true })
        end
        map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next Hunk")
        map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last")  end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>",  "Stage Hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>",  "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer,                       "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk,                    "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer,                       "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline,                "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end,             "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis,                           "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end,       "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",     "GitSigns Select Hunk")
      end,
    },
  },

  -- --------------------------------------------------------------------------
  -- MINI.ICONS (used by bufferline, neo-tree, etc.)
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"]            = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      -- make mini.icons act as nvim-web-devicons so plugins work transparently
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- --------------------------------------------------------------------------
  -- NUI (required by neo-tree and noice)
  -- --------------------------------------------------------------------------
  { "MunifTanjim/nui.nvim", lazy = true },

  -- --------------------------------------------------------------------------
  -- TREESITTER
  -- --------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent    = { enable = true },
      ensure_installed = {
        "bash", "c", "diff", "html", "javascript", "json",
        "lua", "luadoc", "markdown", "markdown_inline",
        "python", "query", "regex", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml", "go",
      },
    },
    config = function(_, opts)
      -- main branch uses require("nvim-treesitter"), not nvim-treesitter.configs
      local ts = require("nvim-treesitter")
      if ts.setup then
        ts.setup(opts)
      else
        -- fallback for older installs that still have configs module
        require("nvim-treesitter.configs").setup(opts)
      end
    end,
  },

  -- --------------------------------------------------------------------------
  -- MARKDOWN RENDERING (in-buffer preview, no server)
  -- --------------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown", "codecompanion" },
    opts = { completions = { lsp = { enabled = true } } },
  },

  -- --------------------------------------------------------------------------
  -- FORMAT ON SAVE (conform) — markdownlint-cli2 --fix
  -- --------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = { markdown = { "markdownlint-cli2" } },
      format_on_save   = { timeout_ms = 3000, lsp_format = "fallback" },
    },
  },

  -- --------------------------------------------------------------------------
  -- LINTING (nvim-lint) — markdownlint-cli2 diagnostics
  -- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { markdown = { "markdownlint-cli2" } }
      local function lint_current_buffer()
        -- nvim-lint pipes via stdin, so config resolution defaults to nvim's cwd —
        -- pass the file's own directory so repo .markdownlint.json/.yaml rules apply
        lint.try_lint(nil, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })
      end
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = lint_current_buffer,
      })
      -- lazy.nvim's `event` trigger fires config() *during* the BufReadPost for the
      -- first file opened, which is too late for the autocmd above to catch that
      -- same event. Calling try_lint synchronously here is also too early — the
      -- linter job's async output gets silently dropped before Neovim finishes
      -- entering — so defer the first lint to the next event-loop tick instead.
      vim.schedule(lint_current_buffer)
    end,
  },

  -- --------------------------------------------------------------------------
  -- COMMENT.NVIM
  -- --------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- --------------------------------------------------------------------------
  -- AUTOPAIRS
  -- --------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- --------------------------------------------------------------------------
  -- LSP
  -- --------------------------------------------------------------------------
  { "neovim/nvim-lspconfig", lazy = true },

  -- --------------------------------------------------------------------------
  -- SIDEKICK (AI sidekick: Copilot NES + AI CLI terminal)
  -- --------------------------------------------------------------------------
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      nes = {
        diff = { inline = "words", show = "always" },
        signs = true,
      },
      cli = {
        win = {
          layout = "right",
          split = { width = 80, height = 20 },
        },
        -- mux disabled by default; enable if you have tmux/zellij
        mux = { enabled = false },
      },
    },
    keys = {
      -- Next Edit Suggestions
      {
        "<Tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      -- AI CLI
      { "<c-.>",      function() require("sidekick.cli").focus() end,                          desc = "Sidekick Focus",          mode = { "n", "t", "i", "x" } },
      { "<leader>aa", function() require("sidekick.cli").toggle() end,                         desc = "AI CLI Toggle" },
      { "<D-b>",      function() require("sidekick.cli").toggle() end,                         desc = "AI CLI Toggle",           mode = { "n", "t", "i", "x" } },
      { "<leader>as", function() require("sidekick.cli").select() end,                         desc = "AI CLI Select" },
      { "<leader>ad", function() require("sidekick.cli").close() end,                          desc = "AI CLI Detach" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end,                         desc = "AI CLI Prompt",           mode = { "n", "x" } },
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,         desc = "AI Send This",            mode = { "n", "x" } },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,         desc = "AI Send File" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,    desc = "AI Send Selection",       mode = { "x" } },
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "AI Toggle Claude" },
      -- NES control
      { "<leader>une", function() require("sidekick.nes").enable() end,    desc = "NES Enable" },
      { "<leader>und", function() require("sidekick.nes").disable() end,   desc = "NES Disable" },
      { "<leader>unt", function() require("sidekick.nes").toggle() end,    desc = "NES Toggle" },
    },
  },

  -- --------------------------------------------------------------------------
  -- COMPLETION
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        }),
      })
    end,
  },

}, {
  -- lazy.nvim opts
  ui = { border = "rounded" },
  checker = { enabled = false },
  change_detection = { notify = false },
})

-- ============================================================================
-- CORE OPTIONS (LazyVim defaults)
-- ============================================================================

local opt = vim.opt

opt.autowrite      = true
opt.clipboard      = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt    = "menu,menuone,noselect"
opt.conceallevel   = 2
opt.confirm        = true
opt.cursorline     = true
opt.expandtab      = true
opt.fillchars      = {
  fold    = " ",
  foldsep = " ",
  eob     = " ",
}
opt.foldlevel      = 99
opt.foldmethod     = "indent"
opt.foldtext       = ""
opt.formatoptions  = "jcroqlnt"
opt.grepformat     = "%f:%l:%c:%m"
opt.grepprg        = "rg --vimgrep"
opt.ignorecase     = true
opt.inccommand     = "nosplit"
opt.jumpoptions    = "view"
opt.laststatus     = 3
opt.linebreak      = true
opt.list           = true
opt.mouse          = "a"
opt.number         = true
opt.pumblend       = 10
opt.pumheight      = 10
opt.relativenumber = true
opt.ruler          = false
opt.scrolloff      = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround     = true
opt.shiftwidth     = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode       = false
opt.sidescrolloff  = 8
opt.signcolumn     = "yes"
opt.smartcase      = true
opt.smartindent    = true
opt.smoothscroll   = true
opt.spelllang      = { "en" }
opt.splitbelow     = true
opt.splitkeep      = "screen"
opt.splitright     = true
opt.tabstop        = 2
opt.termguicolors  = true
opt.timeoutlen     = 300
opt.undofile       = true
opt.undolevels     = 10000
opt.updatetime     = 200
opt.virtualedit    = "block"
opt.wildmode       = "longest:full,full"
opt.winminwidth    = 5
opt.wrap           = false

vim.g.markdown_recommended_style = 0

-- ============================================================================
-- LSP SETUP
-- ============================================================================

vim.lsp.config("gopls", {
  cmd = { os.getenv("HOME") .. "/go/bin/gopls" },
})
vim.lsp.enable("gopls")

-- Copilot LSP (required by sidekick.nvim for Next Edit Suggestions)
-- Install: npm install -g @github/copilot-language-server
-- Sign in after install: :LspCopilotSignIn
vim.lsp.config("copilot", {
  cmd = { "copilot-language-server", "--stdio" },
  root_markers = { ".git" },
  init_options = {
    editorInfo       = { name = "Neovim", version = tostring(vim.version()) },
    editorPluginInfo = { name = "Neovim", version = tostring(vim.version()) },
  },
  settings = { telemetry = { telemetryLevel = "all" } },
})
vim.lsp.enable("copilot")

-- Global Copilot sign-in/out commands (work from any buffer, not just on_attach)
local function copilot_request(method, cb)
  local clients = vim.lsp.get_clients({ name = "copilot" })
  if #clients == 0 then
    vim.notify("Copilot LSP not attached. Open a file first.", vim.log.levels.WARN)
    return
  end
  clients[1]:request(method, vim.empty_dict(), cb)
end

vim.api.nvim_create_user_command("LspCopilotSignIn", function()
  copilot_request("signIn", function(err, result)
    if err then vim.notify(err.message, vim.log.levels.ERROR); return end
    if result.status == "AlreadySignedIn" then
      vim.notify("Already signed in as " .. result.user)
    elseif result.userCode then
      local code = result.userCode
      vim.fn.setreg("+", code); vim.fn.setreg("*", code)
      vim.notify("Code " .. code .. " copied to clipboard. Visit: " .. (result.verificationUri or "https://github.com/login/device"))
    end
  end)
end, { desc = "Sign in to GitHub Copilot" })

vim.api.nvim_create_user_command("LspCopilotSignOut", function()
  copilot_request("signOut", function(_, result)
    if result and result.status == "NotSignedIn" then
      vim.notify("Not signed in.")
    else
      vim.notify("Signed out of Copilot.")
    end
  end)
end, { desc = "Sign out of GitHub Copilot" })

-- ============================================================================
-- KEYMAPS
-- ============================================================================

local keymap = vim.keymap.set

-- ESCAPE in insert mode
keymap("i", "jk", "<Esc>", { noremap = true, desc = "Escape" })

-- Clear search on Escape
keymap({ "i", "n", "s" }, "<Esc>", function()
  vim.cmd("noh")
  return "<Esc>"
end, { expr = true, noremap = true, desc = "Escape and Clear hlsearch" })

-- Auto-close braces on Enter (keep your custom logic)
keymap("i", "<CR>", function()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line    = vim.api.nvim_get_current_line()
  local closing = nil

  if line:match("{%s*$") then
    closing = "}"
  elseif line:match("%(%s*$") then
    closing = ")"
  end

  if closing then
    local indent       = line:match("^%s*") or ""
    local inner_indent = indent .. "  "
    vim.api.nvim_buf_set_lines(0, row, row, false, { inner_indent, indent .. closing })
    vim.api.nvim_win_set_cursor(0, { row + 1, #inner_indent })
    vim.cmd("startinsert")
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false
    )
  end
end, { noremap = true, desc = "Smart Enter / auto-close brace" })

-- Better j/k with visual wrap
keymap({ "n", "x" }, "j",      "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k",      "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "<Up>",   "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { noremap = true, desc = "Go to Left Window" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, desc = "Go to Lower Window" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, desc = "Go to Upper Window" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, desc = "Go to Right Window" })

-- Window resize
keymap("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase Window Height" })
keymap("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease Window Height" })
keymap("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move lines
keymap("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                              { desc = "Move Down" })
keymap("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",                        { desc = "Move Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                              { desc = "Move Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                              { desc = "Move Up" })
keymap("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",                  { desc = "Move Down" })
keymap("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",            { desc = "Move Up" })

-- Save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Markdown render toggle
keymap("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown Render" })

-- Save / quit
keymap("n", "<leader>w",  "<cmd>w<cr>",  { noremap = true, desc = "Save" })
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Better indenting in visual
keymap("x", "<", "<gv", { desc = "Indent Left" })
keymap("x", ">", ">gv", { desc = "Indent Right" })

-- Add undo break-points in insert
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Saner n/N search direction
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap("x", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" })
keymap("o", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap("x", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" })
keymap("o", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result" })

-- Redraw / clear hlsearch / diff update
keymap("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- Keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- New file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Commenting
keymap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
keymap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Diagnostics
local function diagnostic_goto(next, severity)
  return function()
    vim.diagnostic.jump({
      count    = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float    = true,
    })
  end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float,         { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true),                     { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false),                    { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true,  "ERROR"),           { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"),           { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true,  "WARN"),            { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"),            { desc = "Prev Warning" })

-- Quickfix / location list
keymap("n", "<leader>xl", function()
  local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = "Location List" })
keymap("n", "<leader>xq", function()
  local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = "Quickfix List" })
keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Window splits
keymap("n", "<leader>-",  "<C-W>s",  { desc = "Split Window Below", remap = true })
keymap("n", "<leader>|",  "<C-W>v",  { desc = "Split Window Right",  remap = true })
keymap("n", "<leader>wd", "<C-W>c",  { desc = "Delete Window",       remap = true })

-- Tab management
keymap("n", "<leader><tab>l",   "<cmd>tablast<cr>",   { desc = "Last Tab" })
keymap("n", "<leader><tab>o",   "<cmd>tabonly<cr>",   { desc = "Close Other Tabs" })
keymap("n", "<leader><tab>f",   "<cmd>tabfirst<cr>",  { desc = "First Tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>",  { desc = "New Tab" })
keymap("n", "<leader><tab>]",   "<cmd>tabnext<cr>",   { desc = "Next Tab" })
keymap("n", "<leader><tab>d",   "<cmd>tabclose<cr>",  { desc = "Close Tab" })
keymap("n", "<leader><tab>[",   "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- LSP keymaps (hover/rename/format — non-picker)
keymap("n", "K",          "<cmd>lua vim.lsp.buf.hover()<cr>",       { noremap = true, desc = "Hover" })
keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>",      { noremap = true, desc = "Rename" })
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { noremap = true, desc = "Code Action" })
keymap("n", "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, { noremap = true, desc = "Format" })

-- Lazy
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- ============================================================================
-- AUTOCMDS (LazyVim defaults)
-- ============================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Reload file when it changes outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Go to last cursor position when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf     = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
      return
    end
    vim.b[buf].user_last_loc = true
    local mark   = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup", "checkhealth", "dap-float", "dbout",
    "gitsigns-blame", "grug-far", "help", "lspinfo",
    "neotest-output", "neotest-output-panel", "neotest-summary",
    "notify", "qf", "spectre_panel", "startuptime", "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
    end)
  end,
})

-- Unlist man pages
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- Wrap + spell for text-like filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap  = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for JSON
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto-create intermediate directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remove trailing whitespace on save (markdown excluded: markdownlint-cli2 owns
-- whitespace there via MD009, and stripping here would eat intentional
-- two-space hard line breaks before conform gets a chance to fix them properly)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trailing_whitespace"),
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" then return end
    vim.cmd("%s/\\s\\+$//e")
  end,
})
