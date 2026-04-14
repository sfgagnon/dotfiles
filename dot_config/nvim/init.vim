set number
set relativenumber
set mouse=a
set autoindent
set tabstop=3
set softtabstop=3
set shiftwidth=3
set smarttab
set encoding=UTF-8
set visualbell
set scrolloff=5
set expandtab
let mapleader = " "

call plug#begin()

Plug 'github/copilot.vim'
Plug 'nickjvandyke/opencode.nvim'
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/preservim/tagbar', {'on': 'TagbarToggle'} " Tagbar for code navigation
Plug 'https://github.com/junegunn/fzf.vim' " Fuzzy Finder, Needs Silversearcher-ag for :Ag
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/mbbill/undotree'
Plug 'https://github.com/tpope/vim-fugitive' "Git commands in vim :Git [git command]
Plug 'https://github.com/lewis6991/gitsigns.nvim' " Deep buffer integration for Git
Plug 'https://github.com/matze/vim-move' " move selected around using <A-j> <A-k> ...
Plug 'vim-python/python-syntax'
Plug 'https://github.com/hrsh7th/nvim-cmp.git' " code completion using LSP
Plug 'kdheepak/lazygit.nvim'
Plug 'saghen/blink.cmp'
Plug 'folke/noice.nvim'
Plug 'folke/which-key.nvim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'sfgagnon/vim-lsp-settings'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'folke/flash.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'mikavilpas/yazi.nvim'
Plug 'stevearc/oil.nvim'

call plug#end()

colorscheme catppuccin-mocha " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

" --- Key mapping ---

nnoremap <C-t> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <F5>  :UndotreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
nnoremap <silent> <Leader>c :bp<BAR>bd#<CR>

" git-move uses Ctr-j / Ctr-k to move lines up/down
let g:move_key_modifier = 'C'
" git-move uses Alt-j / Alt-k to move blocks up/down
let g:move_key_modifier_visualmode = 'A'

" undotree settings
if has("persistent_undo")
  let target_path = expand('~/.undodir')
  if !isdirectory(target_path)
    call mkdir(target_path, "p", 0700)
  endif
  let &undodir=target_path
  set undofile
endif
let g:undotree_WindowLayout = 4

lua << EOF
vim.opt.list = true
vim.opt.listchars = {
  tab   = "▸ ",
  trail = "·",
  eol   = "↲",
  nbsp  = "␣",
}
EOF


lua << EOF
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation: ]c / [c to jump between hunks (respects diff mode)
    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal({']c', bang = true})
      else gs.nav_hunk('next') end
    end, { desc = 'Next hunk' })

    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({'[c', bang = true})
      else gs.nav_hunk('prev') end
    end, { desc = 'Prev hunk' })

    -- Hunk actions
    map('n', '<leader>hs', gs.stage_hunk,   { desc = 'Stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk,   { desc = 'Reset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })

    -- Visual mode: stage/reset selected lines only
    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Stage hunk (visual)' })
    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'Reset hunk (visual)' })

    -- Preview
    map('n', '<leader>hp', gs.preview_hunk,        { desc = 'Preview hunk' })
    map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })

    -- Blame
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame line' })
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })

    -- Diff
    map('n', '<leader>hd', gs.diffthis,                        { desc = 'Diff this' })
    map('n', '<leader>hD', function() gs.diffthis('~') end,    { desc = 'Diff this ~' })
    map('n', '<leader>tw', gs.toggle_word_diff,                { desc = 'Toggle word diff' })

    -- Quickfix
    map('n', '<leader>hq', gs.setqflist,                             { desc = 'Hunk quickfix (buffer)' })
    map('n', '<leader>hQ', function() gs.setqflist('all') end,       { desc = 'Hunk quickfix (all)' })

    -- Text object: select hunk with ih in operator/visual mode
    map({'o', 'x'}, 'ih', gs.select_hunk, { desc = 'Select hunk' })
  end,
})

require('flash').setup({})

require('nvim-treesitter').setup({
  highlight = { enable = true },
  indent    = { enable = true },
})
require'nvim-treesitter'.install { 'bash', 'make', 'markdown', 'python', 'systemverilog', 'tcl', 'vhdl', 'xml', 'yaml' }

-- flash.nvim standard keymaps
vim.keymap.set({'n','x','o'}, 's',     function() require('flash').jump() end, { desc = "Flash" })
vim.keymap.set({'n','x','o'}, 'S',     function() require('flash').treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set('o',           'r',     function() require('flash').remote() end, { desc = "Remote Flash" })
vim.keymap.set({'o','x'},     'R',     function() require('flash').treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set('c',           '<c-s>', function() require('flash').toggle() end, { desc = "Toggle Flash Search" })
EOF

lua << EOF
vim.o.autoread = true -- Required for `opts.events.reload`

-- Recommended/example keymaps
vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
EOF

lua << EOF
require('yazi').setup({
  open_for_directories = false,
  keymaps = {
    show_help = "<f1>",
  },
})

-- Open yazi at the current file
vim.keymap.set({ "n", "v" }, "<leader>y", "<cmd>Yazi<cr>",     { desc = "Open yazi at current file" })
-- Open yazi in Neovim's working directory
vim.keymap.set("n",          "<leader>Y", "<cmd>Yazi cwd<cr>", { desc = "Open yazi in cwd" })
-- Resume last yazi session
vim.keymap.set("n",          "<leader>yr","<cmd>Yazi toggle<cr>", { desc = "Resume last yazi session" })
EOF

lua << EOF
require("oil").setup()
EOF
