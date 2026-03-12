-- Claude-inspired warm colorscheme for Neovim
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "claude"
vim.o.background = "dark"

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Palette
local bg        = "#1A1714"
local bg_dark   = "#141210"
local bg_light  = "#2A2520"
local bg_sel    = "#3A332C"
local bg_visual = "#4A3F35"
local fg        = "#E8E0D8"
local fg_dim    = "#C8BEB4"
local fg_muted  = "#7A7068"
local fg_dark   = "#5C534A"
local terra     = "#D97757"
local terra_br  = "#E89578"
local green     = "#7DAE82"
local green_br  = "#9BC49F"
local yellow    = "#D4A857"
local yellow_br = "#E2C07A"
local blue      = "#7B9EBF"
local blue_br   = "#9BB8D4"
local magenta   = "#B588B0"
local magenta_br= "#CDA4C8"
local cyan      = "#6FAFAF"
local cyan_br   = "#8EC7C7"

-- Editor
hi("Normal",       { fg = fg, bg = bg })
hi("NormalFloat",  { fg = fg, bg = bg_dark })
hi("FloatBorder",  { fg = fg_muted, bg = bg_dark })
hi("Cursor",       { fg = bg, bg = terra })
hi("CursorLine",   { bg = bg_light })
hi("CursorLineNr", { fg = terra, bold = true })
hi("LineNr",       { fg = fg_dark })
hi("SignColumn",   { bg = bg })
hi("ColorColumn",  { bg = bg_light })
hi("Visual",       { bg = bg_visual })
hi("VisualNOS",    { bg = bg_visual })
hi("Search",       { fg = bg, bg = yellow })
hi("IncSearch",    { fg = bg, bg = terra })
hi("CurSearch",    { fg = bg, bg = terra })
hi("Substitute",   { fg = bg, bg = terra })
hi("MatchParen",   { fg = terra_br, bold = true, underline = true })

-- Statusline & tabline
hi("StatusLine",   { fg = fg_dim, bg = bg_dark })
hi("StatusLineNC", { fg = fg_muted, bg = bg_dark })
hi("TabLine",      { fg = fg_muted, bg = bg_dark })
hi("TabLineFill",  { bg = bg_dark })
hi("TabLineSel",   { fg = fg, bg = bg })
hi("WinSeparator", { fg = bg_light })

-- Popup menu
hi("Pmenu",        { fg = fg_dim, bg = bg_dark })
hi("PmenuSel",     { fg = fg, bg = bg_sel })
hi("PmenuSbar",    { bg = bg_light })
hi("PmenuThumb",   { bg = fg_muted })

-- Messages
hi("ErrorMsg",     { fg = terra_br, bold = true })
hi("WarningMsg",   { fg = yellow })
hi("MoreMsg",      { fg = green })
hi("Question",     { fg = blue })
hi("ModeMsg",      { fg = fg_dim, bold = true })

-- Diff
hi("DiffAdd",      { bg = "#2A3328" })
hi("DiffChange",   { bg = "#2A2820" })
hi("DiffDelete",   { bg = "#3A2520" })
hi("DiffText",     { bg = "#3A3320", bold = true })

-- Folding & special
hi("Folded",       { fg = fg_muted, bg = bg_light })
hi("FoldColumn",   { fg = fg_dark, bg = bg })
hi("NonText",      { fg = fg_dark })
hi("SpecialKey",   { fg = fg_dark })
hi("Whitespace",   { fg = bg_light })
hi("EndOfBuffer",  { fg = bg })
hi("Directory",    { fg = blue })
hi("Title",        { fg = terra, bold = true })
hi("Conceal",      { fg = fg_muted })

-- Syntax
hi("Comment",      { fg = fg_muted, italic = true })
hi("Constant",     { fg = terra })
hi("String",       { fg = green })
hi("Character",    { fg = green_br })
hi("Number",       { fg = terra_br })
hi("Boolean",      { fg = terra })
hi("Float",        { fg = terra_br })

hi("Identifier",   { fg = fg })
hi("Function",     { fg = blue })

hi("Statement",    { fg = magenta })
hi("Conditional",  { fg = magenta })
hi("Repeat",       { fg = magenta })
hi("Label",        { fg = magenta_br })
hi("Operator",     { fg = fg_dim })
hi("Keyword",      { fg = magenta, italic = true })
hi("Exception",    { fg = terra })

hi("PreProc",      { fg = cyan })
hi("Include",      { fg = cyan })
hi("Define",       { fg = cyan })
hi("Macro",        { fg = cyan_br })
hi("PreCondit",    { fg = cyan })

hi("Type",         { fg = yellow })
hi("StorageClass", { fg = yellow })
hi("Structure",    { fg = yellow })
hi("Typedef",      { fg = yellow_br })

hi("Special",      { fg = terra })
hi("SpecialChar",  { fg = terra_br })
hi("Tag",          { fg = blue })
hi("Delimiter",    { fg = fg_dim })
hi("Debug",        { fg = terra })

hi("Underlined",   { fg = blue, underline = true })
hi("Bold",         { bold = true })
hi("Italic",       { italic = true })
hi("Ignore",       { fg = fg_dark })
hi("Error",        { fg = terra_br, bold = true })
hi("Todo",         { fg = yellow, bg = bg_light, bold = true })

-- Diagnostics
hi("DiagnosticError",          { fg = terra_br })
hi("DiagnosticWarn",           { fg = yellow })
hi("DiagnosticInfo",           { fg = blue })
hi("DiagnosticHint",           { fg = cyan })
hi("DiagnosticUnderlineError", { undercurl = true, sp = terra_br })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = yellow })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = blue })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = cyan })

-- LSP
hi("LspReferenceText",  { bg = bg_sel })
hi("LspReferenceRead",  { bg = bg_sel })
hi("LspReferenceWrite", { bg = bg_sel, bold = true })
hi("LspInlayHint",      { fg = fg_dark, italic = true })
hi("LspSignatureActiveParameter", { fg = terra, bold = true })

-- Treesitter
hi("@variable",           { fg = fg })
hi("@variable.builtin",   { fg = terra, italic = true })
hi("@variable.parameter", { fg = fg_dim })
hi("@variable.member",    { fg = fg_dim })
hi("@constant",           { fg = terra })
hi("@constant.builtin",   { fg = terra, bold = true })
hi("@module",             { fg = yellow })
hi("@string",             { fg = green })
hi("@string.escape",      { fg = cyan })
hi("@string.regex",       { fg = cyan_br })
hi("@character",          { fg = green_br })
hi("@number",             { fg = terra_br })
hi("@boolean",            { fg = terra })
hi("@float",              { fg = terra_br })
hi("@function",           { fg = blue })
hi("@function.builtin",   { fg = blue_br })
hi("@function.call",      { fg = blue })
hi("@function.method",    { fg = blue })
hi("@constructor",        { fg = yellow })
hi("@keyword",            { fg = magenta, italic = true })
hi("@keyword.function",   { fg = magenta })
hi("@keyword.return",     { fg = magenta })
hi("@keyword.operator",   { fg = magenta_br })
hi("@operator",           { fg = fg_dim })
hi("@type",               { fg = yellow })
hi("@type.builtin",       { fg = yellow, italic = true })
hi("@type.qualifier",     { fg = magenta, italic = true })
hi("@punctuation.bracket",   { fg = fg_muted })
hi("@punctuation.delimiter", { fg = fg_muted })
hi("@comment",            { fg = fg_muted, italic = true })
hi("@tag",                { fg = terra })
hi("@tag.attribute",      { fg = yellow })
hi("@tag.delimiter",      { fg = fg_muted })
hi("@attribute",          { fg = cyan })
hi("@property",           { fg = fg_dim })
hi("@label",              { fg = magenta_br })
hi("@namespace",          { fg = yellow })

-- Git signs
hi("GitSignsAdd",    { fg = green })
hi("GitSignsChange", { fg = yellow })
hi("GitSignsDelete", { fg = terra })

-- Telescope
hi("TelescopeBorder",     { fg = fg_muted, bg = bg_dark })
hi("TelescopeNormal",     { fg = fg, bg = bg_dark })
hi("TelescopeSelection",  { bg = bg_sel })
hi("TelescopeMatching",   { fg = terra, bold = true })
hi("TelescopePromptPrefix", { fg = terra })
hi("TelescopeTitle",      { fg = terra, bold = true })

-- NvimTree
hi("NvimTreeNormal",      { fg = fg_dim, bg = bg_dark })
hi("NvimTreeFolderName",  { fg = blue })
hi("NvimTreeFolderIcon",  { fg = yellow })
hi("NvimTreeOpenedFolderName", { fg = blue_br })
hi("NvimTreeRootFolder",  { fg = terra, bold = true })
hi("NvimTreeSpecialFile", { fg = yellow })
hi("NvimTreeIndentMarker",{ fg = bg_light })
hi("NvimTreeGitDirty",    { fg = yellow })
hi("NvimTreeGitNew",      { fg = green })
hi("NvimTreeGitDeleted",  { fg = terra })
hi("NvimTreeWinSeparator",{ fg = bg_dark, bg = bg_dark })

-- Indent guides / misc
hi("IndentBlanklineChar",        { fg = bg_light })
hi("IndentBlanklineContextChar", { fg = bg_sel })

-- Cmp
hi("CmpItemAbbrMatch",      { fg = terra, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = terra_br })
hi("CmpItemKindFunction",   { fg = blue })
hi("CmpItemKindVariable",   { fg = fg_dim })
hi("CmpItemKindKeyword",    { fg = magenta })
hi("CmpItemKindText",       { fg = fg_muted })
hi("CmpItemKindModule",     { fg = yellow })
hi("CmpItemKindStruct",     { fg = yellow })
hi("CmpItemKindSnippet",    { fg = cyan })
