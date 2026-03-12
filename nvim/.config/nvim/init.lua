-- =====================================================================
-- Minimal Neovim IDE (Rust‑first). Clean and tight; batteries-included.
-- - Plugin manager: lazy.nvim
-- - LSP: rust-analyzer via rustaceanvim + mason for tooling
-- - Completion: nvim-cmp (no snippets needed)
-- - Treesitter: fast syntax highlight/indent
-- - Quality-of-life: telescope, lualine, nvim-tree, toggleterm, autopairs
-- =====================================================================

-- ---------------- Core ----------------
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff  = 6
vim.opt.undofile   = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- ---------------- Bootstrap lazy.nvim ----------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------- Plugins ----------------
require("lazy").setup({
  -- vague kept as fallback if needed
  { "vague-theme/vague.nvim", lazy = true },
  

{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      mappings = false, -- disable default gc/gb so you don’t conflict
    })

    -- Normal-mode: toggle line comment
    vim.keymap.set("n", "<leader>c", function()
      require("Comment.api").toggle.linewise.current()
    end, { silent = true })

    -- Visual-mode: toggle selected block
    vim.keymap.set("v", "<leader>c", function()
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { silent = true })

    -- Optional: block comment instead of linewise
    -- Normal:
    vim.keymap.set("n", "<leader>b", function()
      require("Comment.api").toggle.blockwise.current()
    end, { silent = true })

    -- Visual:
    vim.keymap.set("v", "<leader>b", function()
      require("Comment.api").toggle.blockwise(vim.fn.visualmode())
    end, { silent = true })
  end
},



  -- File explorer & terminal
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  "akinsho/toggleterm.nvim",

  -- Fuzzy find & statusline
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "nvim-lualine/lualine.nvim",

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "VeryLazy",
      priority = 1000,
  }, 
  "windwp/nvim-spectre",
  "mg979/vim-visual-multi",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "bash", "json", "toml", "rust" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- Format on save
  "stevearc/conform.nvim",

  -- Autopairs
  "windwp/nvim-autopairs",

  -- LSP tooling (install servers/debuggers/formatters via :Mason)
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },

  -- Rust first-class experience (successor to rust-tools)
  -- Exposes :RustLsp commands and config via vim.g.rustaceanvim
  { "mrcjkb/rustaceanvim", version = "^4" },
}, { ui = { border = "rounded" } })

-- ---------------- UI: tree + term + theme ----------------
require("nvim-tree").setup({ view = { width = 30, side = "left" }, renderer = { group_empty = true }, hijack_cursor = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })

require("toggleterm").setup({
  direction = "horizontal",
  open_mapping = [[<C-\>]],
  size = function() return math.floor(vim.o.lines * 0.33) end,
})
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { silent = true, desc = "Toggle terminal" })

-- Lualine theme matching Claude palette
local claude_lualine = {
  normal = {
    a = { fg = "#1A1714", bg = "#7B9EBF", gui = "bold" },
    b = { fg = "#C8BEB4", bg = "#2A2520" },
    c = { fg = "#7A7068", bg = "#141210" },
  },
  insert = {
    a = { fg = "#1A1714", bg = "#7DAE82", gui = "bold" },
  },
  visual = {
    a = { fg = "#1A1714", bg = "#B588B0", gui = "bold" },
  },
  replace = {
    a = { fg = "#1A1714", bg = "#D97757", gui = "bold" },
  },
  command = {
    a = { fg = "#1A1714", bg = "#D4A857", gui = "bold" },
  },
  inactive = {
    a = { fg = "#5C534A", bg = "#141210" },
    b = { fg = "#5C534A", bg = "#141210" },
    c = { fg = "#5C534A", bg = "#141210" },
  },
}
require("lualine").setup({ options = { theme = claude_lualine, section_separators = "", component_separators = "" } })

vim.o.background = "dark"
vim.cmd.colorscheme("claude")

-- ---------------- Diagnostics UX ----------------
vim.diagnostic.config({
  --virtual_text = { prefix = "●", spacing = 2 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostics → quickfix" })
local spectre = require("spectre")
vim.keymap.set("n", "<leader>sr", spectre.toggle, { desc = "Spectre: search & replace" })
vim.keymap.set("n", "<leader>sw", function() spectre.open_visual({ select_word = true }) end,
  { desc = "Spectre: current word" })
-- ---------------- Completion (no snippets) ----------------
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" } }, { { name = "buffer" }, { name = "path" } }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = false --cmp.config.window.bordered(),
  },
})

-- ---------------- Formatting ----------------
require("conform").setup({
  formatters_by_ft = {
    rust = { "rustfmt" },
    lua  = { "stylua" },
    json = { "jq" },
  },
})
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require("conform").format({ async = false, lsp_fallback = true })
  end,
})

-- ---------------- LSP: Common on_attach & capabilities ----------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  -- Essentials
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, "List references")
  map("n", "E",  vim.lsp.buf.hover, "Hover docs")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>f", function() vim.lsp.buf.format({ async = false }) end, "Format buffer")
  -- Inlay hints toggle
  map("n", "<leader>ih", function()
    local b = vim.api.nvim_get_current_buf()
    local enabled = vim.lsp.inlay_hint.is_enabled and vim.lsp.inlay_hint.is_enabled(b)
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = b })
  end, "Toggle inlay hints")
end



-- Haskell LSP (haskell-language-server via vim.lsp.start)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "haskell",
  callback = function(args)
    vim.lsp.start({
      name = "hls",
      cmd = { "haskell-language-server-wrapper", "--lsp" },
      root_dir = vim.fs.root(
        vim.api.nvim_buf_get_name(args.buf),
        { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml", ".git" }
      ),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        haskell = {
          formattingProvider = "ormolu", -- or "fourmolu" if you install it
        },
      },
    })
  end,
})
-- ---------------- Rust (first class) ----------------
-- Install rust-analyzer via :Mason if you don't have it on PATH.
-- rustaceanvim picks up this table automatically.
vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
        completion = { autoself = { enable = true } },
        diagnostics = { experimental = { enable = true } },
        inlayHints = { lifetimeElisionHints = { enable = true } },
      },
    },
  },
  tools = {
    test_executor = "background",
  },
}

-- ---------------- Telescope keymaps ----------------
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", tb.live_grep,  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", tb.buffers,    { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", tb.help_tags,  { desc = "Help tags" })
vim.keymap.set("n", "<leader>fw", tb.grep_string, { desc = "Word under cursor" })
vim.keymap.set("n", "<leader>fo", tb.oldfiles,    { desc = "Recent files" })

-- ---------------- Window helpers ----------------
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>sh", ":split<CR>",  { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>sx", ":close<CR>",  { desc = "Close split" })

-- Move line/block up/down (Alt+j / Alt+k)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move block down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move block up" })

-- Terminal navigation
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true, desc = "Exit terminal mode" })

-- ---------------- Autopairs x cmp ----------------
require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },
  enable_check_bracket_line = true,
  ignored_next_char = "[%w%.]",
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())


require("tiny-inline-diagnostic").setup({
	preset = "powerline"
   })

vim.keymap.set("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
local addr = vim.fn.stdpath("run") .. "/nvim-" .. vim.fn.getpid()
vim.fn.serverstart(addr)
vim.env.NVIM_LISTEN_ADDRESS = addr


-- ---------------- Finish: How to use ----------------
-- 1) :Lazy sync
-- 2) :Mason (install rust-analyzer if not on PATH)
-- 3) Open a Rust project (with Cargo.toml). rustaceanvim will auto-start.
--    - K → hover docs
--    - gd/gi/gr → defs/impls/refs
--    - <leader>rn / <leader>ca → rename/code actions
--    - <leader>ih → toggle inlay hints
--    - <leader>f → format (rustfmt)
-- 4) <leader>e toggles file tree, <C-\> toggles terminal
