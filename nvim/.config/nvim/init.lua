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
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
    config = function()
      require("github-theme").setup({})
    end,
  },


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
  {     
        "nvim-tree/nvim-tree.lua", 
        dependencies = { "nvim-tree/nvim-web-devicons" }, 
        
    },
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
  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Add Cursor Up"]      = "<M-k>",
        ["Add Cursor Down"]    = "<M-j>",
        ["Select All"]         = "<leader>m",
        ["Visual All"]         = "<leader>m",
        ["Skip Region"]        = "<C-x>",
        ["Remove Region"]      = "<C-p>",
      }
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    -- textobjects must track the same branch as the core (master); its `main`
    -- branch is a rewrite incompatible with the nvim-treesitter.configs API.
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
    opts = {
      ensure_installed = { "lua", "vim", "bash", "json", "toml", "rust", "ocaml", "ocaml_interface" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true, disable = { "ocaml" } },
      -- Function/impl-aware motions and text objects (great for Rust impl blocks)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",   -- impl / struct / enum block
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
        },
      },
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
  -- No version pin: track the latest release, which targets Neovim 0.11's
  -- LSP API (the old ^4 line used a deprecated make_position_params call).
  { "mrcjkb/rustaceanvim", version = false },

  -- Cargo.toml dependency management: inline version hints + upgrade actions
  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        completion = { cmp = { enabled = true } },
      })
    end,
  },

  -- Diagnostics / quickfix / references panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Leader-key discoverability popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Debugging (nvim-dap). codelldb installed via :Mason; rustaceanvim's
  -- :RustLsp debuggables drives this for Rust.
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },
}, { ui = { border = "rounded" } })

-- ---------------- UI: tree + term + theme ----------------
require("nvim-tree").setup({ view = { width = 30, side = "left" }, renderer = { group_empty = true }, hijack_cursor = true, filters = {
    dotfiles = true,
    custom = { "node_modules", ".git", ".cargo" },
  }, })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })

require("toggleterm").setup({
  direction = "horizontal",
  open_mapping = [[<C-\>]],
  size = function() return math.floor(vim.o.lines * 0.33) end,
})
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { silent = true, desc = "Toggle terminal" })

-- bacon: background `cargo clippy` watcher in a dedicated float. Recompiles on
-- save and shows errors instantly without blocking the editor. Requires the
-- `bacon` binary (cargo install bacon).
local bacon_term
vim.keymap.set("n", "<leader>tb", function()
  if not bacon_term then
    bacon_term = require("toggleterm.terminal").Terminal:new({
      cmd = "bacon clippy",
      direction = "float",
      float_opts = { border = "rounded" },
      hidden = true,
    })
  end
  bacon_term:toggle()
end, { silent = true, desc = "Toggle bacon (cargo clippy watcher)" })

require("lualine").setup({ options = { theme = "github_dark_default", section_separators = "", component_separators = "" } })

vim.o.background = "dark"
vim.cmd.colorscheme("github_dark_default")

-- Transparent background (relies on terminal opacity, e.g. wezterm window_background_opacity)
local function make_transparent()
  for _, group in ipairs({
    "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
    "SignColumn", "LineNr", "EndOfBuffer", "VertSplit", "WinSeparator",
    "StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
    "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
    "TelescopeNormal", "TelescopeBorder",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end
end
make_transparent()
vim.api.nvim_create_autocmd("ColorScheme", { callback = make_transparent })

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

-- Trouble: diagnostics / references panels
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble: workspace diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Trouble: buffer diagnostics" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", { desc = "Trouble: references" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<CR>", { desc = "Trouble: symbols" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Trouble: quickfix" })
local spectre = require("spectre")
vim.keymap.set("n", "<leader>sr", spectre.toggle, { desc = "Spectre: search & replace" })
vim.keymap.set("n", "<leader>sw", function() spectre.open_visual({ select_word = true }) end,
  { desc = "Spectre: current word" })
-- ---------------- Completion (no snippets) ----------------
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.confirm({ select = true }) else fallback() end
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

-- Cargo.toml: add the crates source for dependency-version completion.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    cmp.setup.buffer({
      sources = cmp.config.sources(
        { { name = "crates" }, { name = "nvim_lsp" } },
        { { name = "buffer" }, { name = "path" } }
      ),
    })
  end,
})

-- ---------------- Formatting ----------------
require("conform").setup({
  formatters_by_ft = {
    rust = { "rustfmt" },
    lua  = { "stylua" },
    json = { "jq" },
    ocaml = { "ocamlformat" },
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

-- ---------------- TypeScript / JavaScript ----------------
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable("ts_ls")

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
-- ---------------- OCaml (first class) ----------------
-- Requires `ocaml-lsp-server` (via opam). Optional: `ocamlformat`, `dune`.
vim.filetype.add({
  extension = {
    ml = "ocaml",
    mli = "ocaml",
    mll = "ocaml",
    mly = "ocaml",
    mlt = "ocaml",
    eliom = "ocaml",
    eliomi = "ocaml",
  },
  filename = {
    ["dune"] = "dune",
    ["dune-project"] = "dune",
    ["dune-workspace"] = "dune",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ocaml", "ocaml.interface", "ocaml.menhir", "ocaml.ocamllex", "dune" },
  callback = function(args)
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].softtabstop = 2
    vim.lsp.start({
      name = "ocamllsp",
      cmd = { "ocamllsp" },
      root_dir = vim.fs.root(
        vim.api.nvim_buf_get_name(args.buf),
        { "dune-project", "dune-workspace", "*.opam", "esy.json", "package.json", ".merlin", ".git" }
      ),
      on_attach = on_attach,
      capabilities = capabilities,
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
        cargo = {
          allFeatures = true,
          buildScripts = { enable = true },
        },
        procMacro = { enable = true },
        -- Run clippy (not just `cargo check`) on save. Newer rust-analyzer
        -- schema: checkOnSave is a boolean, check.command selects the tool.
        checkOnSave = true,
        check = { command = "clippy" },
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

-- Rust-specific keymaps: override the generic LSP maps with rustaceanvim's
-- richer :RustLsp equivalents in Rust buffers only.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(args)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
    end
    -- Hover actions (docs + jump to docs.rs, etc.); press again to enter the popup
    map("K", function() vim.cmd.RustLsp("hover", "actions") end, "Rust hover actions")
    -- Grouped Rust code actions
    map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Rust code action")
    -- Run / debug the thing under the cursor (test, bin, example…)
    map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Rust runnables")
    map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Rust debuggables")
    -- Macro expansion, parent module, Cargo.toml
    map("<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
    map("<leader>rp", function() vim.cmd.RustLsp({ "parentModule" }) end, "Parent module")
    map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
    -- Render diagnostic explanation (rustc --explain style)
    map("<leader>re", function() vim.cmd.RustLsp("explainError") end, "Explain error")
  end,
})

-- ---------------- DAP: codelldb adapter + keymaps ----------------
-- Install the debugger with `:MasonInstall codelldb`. rustaceanvim auto-detects
-- a Mason-installed codelldb and uses it for :RustLsp debuggables; the explicit
-- adapter below also lets nvim-dap launch/attach directly.
local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
local codelldb_path = mason_pkg .. "/extension/adapter/codelldb"
if vim.fn.executable(codelldb_path) == 1 then
  local dap = require("dap")
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }
end

local dap = require("dap")
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "DAP: continue/start" })
vim.keymap.set("n", "<leader>dn", dap.step_over,         { desc = "DAP: step over" })
vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "DAP: step into" })
vim.keymap.set("n", "<leader>do", dap.step_out,          { desc = "DAP: step out" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle,       { desc = "DAP: toggle REPL" })
vim.keymap.set("n", "<leader>dx", dap.terminate,         { desc = "DAP: terminate" })
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP: toggle UI" })

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
vim.keymap.set("n", "<leader>j", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<leader>k", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move block down" })
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move block up" })

-- Terminal navigation
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true, desc = "Exit terminal mode" })

-- Window focus nav (layout-independent: physical arrow keys)
vim.keymap.set("n", "<C-Left>",  "<C-w>h", { silent = true, desc = "Focus left window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { silent = true, desc = "Focus right window" })
vim.keymap.set("n", "<C-Up>",    "<C-w>k", { silent = true, desc = "Focus upper window" })
vim.keymap.set("n", "<C-Down>",  "<C-w>j", { silent = true, desc = "Focus lower window" })
vim.keymap.set("t", "<C-Left>",  [[<C-\><C-n><C-w>h]], { silent = true, desc = "Focus left window" })
vim.keymap.set("t", "<C-Right>", [[<C-\><C-n><C-w>l]], { silent = true, desc = "Focus right window" })
vim.keymap.set("t", "<C-Up>",    [[<C-\><C-n><C-w>k]], { silent = true, desc = "Focus upper window" })
vim.keymap.set("t", "<C-Down>",  [[<C-\><C-n><C-w>j]], { silent = true, desc = "Focus lower window" })

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
