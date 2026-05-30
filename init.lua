-- ============================================================================
-- NEOVIM CONFIG - MINIMAL BEGINNER SETUP
-- ============================================================================

-- ============================================================================
-- VIM-PLUG SETUP & PLUGINS
-- ============================================================================

local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('catppuccin/nvim', { as = 'catppuccin' })
Plug('nvim-tree/nvim-tree.lua')
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('windwp/nvim-autopairs')
Plug('numToStr/comment.nvim')

vim.call('plug#end')

-- ============================================================================
-- CORE SETTINGS
-- ============================================================================

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.undofile = true
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300

-- ============================================================================
-- PLUGIN CONFIGURATION
-- ============================================================================

-- COLORSCHEME
vim.cmd('colorscheme catppuccin-mocha')

-- NVIM-TREE
require('nvim-tree').setup({
  view = {
    width = 30,
    side = 'right',
  },
})

-- COMMENT.NVIM
local comment_ok, comment = pcall(require, 'Comment')
if comment_ok then
  comment.setup()
end

-- ============================================================================
-- CUSTOM KEYBINDINGS
-- ============================================================================

-- Leader key = Space
vim.g.mapleader = ' '

local keymap = vim.keymap.set

-- ESCAPE SEQUENCES
keymap('i', 'jk', '<Esc>', { noremap = true })

-- Enter key: auto-close braces/parens with proper indentation
keymap('i', '<CR>', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local closing = nil

  -- Check if line ends with { or (
  if line:match('{%s*$') then
    closing = '}'
  elseif line:match('%(%s*$') then
    closing = ')'
  end

  if closing then
    local indent = line:match('^%s*') or ''
    local inner_indent = indent .. '  '

    -- Insert blank line and closing brace/paren
    vim.api.nvim_buf_set_lines(0, row, row, false, { inner_indent, indent .. closing })

    -- Move to new line and position at end of indentation
    vim.api.nvim_win_set_cursor(0, { row + 1, #inner_indent })

    -- Start insert mode
    vim.cmd('startinsert')
  else
    -- Normal Enter key
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
  end
end, { noremap = true })

-- FILE OPERATIONS
keymap('n', '<leader>w', ':w<CR>', { noremap = true })
keymap('n', '<leader>q', ':q<CR>', { noremap = true })
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true })

-- NAVIGATION
keymap('n', '<C-h>', '<C-w>h', { noremap = true })
keymap('n', '<C-j>', '<C-w>j', { noremap = true })
keymap('n', '<C-k>', '<C-w>k', { noremap = true })
keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- LINE MOVEMENT
keymap('n', 'H', 'g^', { noremap = true })
keymap('n', 'L', 'g$', { noremap = true })
keymap('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })
keymap('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })

-- SEARCH
keymap('n', '<leader>nh', ':nohlsearch<CR>', { noremap = true })

-- COMMENTS
keymap('n', '<leader>c', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true })

-- LSP
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true })
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true })
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true })
keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true })
keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true })

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

-- Configure gopls with explicit path
vim.lsp.config('gopls', {
  cmd = { os.getenv('HOME') .. '/go/bin/gopls' },
})

-- Enable gopls for Go files
vim.lsp.enable('gopls')

-- Setup completion
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
  cmp.setup({
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
  })
end

-- ============================================================================
-- GENERAL AUTOCMDS
-- ============================================================================

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.cmd('%s/\\s\\+$//e')
  end,
})
