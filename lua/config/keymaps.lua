local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Exit insert mode
map("i", "jj", "<Esc>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Misc
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic [Q]uick fix list" })
map("n", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal mode" })

-- Window
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Telescope Plugin
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
map("n", "<leader>sg", ":Telescope live_grep<CR>", opts)
