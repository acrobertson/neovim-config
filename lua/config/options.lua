-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- auto format
vim.g.autoformat = true

-- Disable animations for the `snacks` plugin
vim.g.snacks_animate = false

-- Show the current document symbols location from Trouble in lualine
vim.g.trouble_lualine = true

-- Appropriately highlight `denols` codefences
---@see https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#denols
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	-- only set clipboard if not in ssh, to make sure the OSC 52
	-- integration works automatically. Requires Neovim >= 0.10.0
	vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)

local opt = vim.opt

-- Enable auto write
opt.autowrite = true

-- Hide * markup for bold and italic, but not markers with substitutions
opt.conceallevel = 2

-- Confirm to save changes before exiting modified buffer
opt.confirm = true

-- Highlight the screen line of the cursor
opt.cursorline = true

-- Folds
opt.foldlevel = 99
opt.foldexpr = "v:lua.require'config.util'.ui.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = ""

-- Formatting
opt.formatoptions = "jcroqlnt" -- tcqj

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

-- Enable ignorecase + smartcase for better searching
opt.ignorecase = true
opt.smartcase = true -- Don't ignore case with capitals
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Preview substitutions live, as you type
opt.inccommand = "split"

opt.jumpoptions = "view"

-- Global statusline
opt.laststatus = 3

-- Wrap long lines at a character in "breakat"
opt.linebreak = true
opt.listchars = { tab = "⇥ ", trail = "·", nbsp = "␣" }
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- Enable mouse support
opt.mouse = "a"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Popups
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Max number of entries in a popup

-- Disable the default ruler
opt.ruler = false

-- Min number of screen lines to keep above and below the cursor
opt.scrolloff = 4
opt.sidescrolloff = 8 -- Columns of context

opt.sessionoptions =
	{ "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Indents
opt.tabstop = 2
opt.shiftwidth = 0
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

-- Don't show mode since we have a statusline
opt.showmode = false

opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Always show the signcolumn; otherwise, it would shift the text each time
opt.signcolumn = "yes"

-- Splits
opt.splitbelow = true -- Open new split below the current window
opt.splitkeep = "screen" -- Keep the screen when splitting
opt.splitright = true -- Open new split to the right of the current window

opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- Time in milliseconds to wait for a mapped sequence to complete
-- Lower than default (1000) to quickly trigger which-key
opt.timeoutlen = vim.g.vscode and 1000 or 300

-- Enable 24-bit RGB color in the UI
opt.termguicolors = true

-- Save undo history
opt.undofile = true
opt.undolevels = 10000

-- Save swap file and trigger CursorHold
opt.updatetime = 2000

-- Allow cursor to move where there is no text in visual block mode
opt.virtualedit = "block"

-- Command-line completion mode
opt.wildmode = "longest:full,full"

-- Minimum window width
opt.winminwidth = 5

-- Global window border default
vim.o.winborder = "rounded"
