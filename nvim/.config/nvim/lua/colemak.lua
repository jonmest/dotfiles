-- Colemak DHk remappings for Neovim
-- Rotation: hjkl → mnei (physical home row), displaced mnei → lhjk
--
-- Navigation:  m=left  n=down  e=up  i=right
-- Displaced:   h=next-search  j=end-of-word  k=insert  l=set-mark

local map = vim.keymap.set
local modes = { "n", "v", "o" }

-- ── Core navigation: hjkl → mnei ──────────────────────────
map(modes, "m", "h", { desc = "Left" })
map(modes, "n", "j", { desc = "Down" })
map(modes, "e", "k", { desc = "Up" })
map(modes, "i", "l", { desc = "Right" })

-- ── Displaced lowercase: mnei → lhjk ─────────────────────
map(modes, "l", "m", { desc = "Set mark" })
map(modes, "h", "n", { desc = "Next search match" })
map(modes, "j", "e", { desc = "End of word" })
map("n", "k", "i", { desc = "Insert" })
map({ "v", "o" }, "k", "i", { desc = "Inner (text object)" })

-- ── Uppercase variants ────────────────────────────────────
map(modes, "M", "H", { desc = "Top of screen" })
map(modes, "N", "J", { desc = "Join lines" })
map(modes, "E", "K", { desc = "Keyword lookup" })
map(modes, "I", "L", { desc = "Last line of screen" })
map(modes, "L", "M", { desc = "Middle of screen" })
map(modes, "H", "N", { desc = "Previous search match" })
map(modes, "J", "E", { desc = "End of WORD" })
map("n", "K", "I", { desc = "Insert at line start" })

-- ── g-prefixed motions ────────────────────────────────────
map(modes, "gn", "gj", { desc = "Down (display line)" })
map(modes, "ge", "gk", { desc = "Up (display line)" })
map(modes, "gj", "ge", { desc = "End of prev word" })
map(modes, "gJ", "gE", { desc = "End of prev WORD" })
map(modes, "gk", "gi", { desc = "Last insert position" })

-- ── Window navigation ─────────────────────────────────────
map("n", "<C-w>m", "<C-w>h", { desc = "Window left" })
map("n", "<C-w>n", "<C-w>j", { desc = "Window down" })
map("n", "<C-w>e", "<C-w>k", { desc = "Window up" })
map("n", "<C-w>i", "<C-w>l", { desc = "Window right" })

-- ── Fold navigation ───────────────────────────────────────
map("n", "zn", "zj", { desc = "Next fold" })
map("n", "ze", "zk", { desc = "Prev fold" })
