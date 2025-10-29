local servers = {
	"clojure_lsp",
	"cssls",
	"denols",
	-- TODO: set up `nvim-emmet`?
	"emmet_language_server",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"nixd",
	"phpactor",
	"tailwindcss",
	-- TODO: switch to twiggy-language-server
	"twig-language-server",
	"vtsls",
	"yamlls",
}

vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
})

-- Set up LSP
Config.lsp.on_attach(function(client, buffer)
	require("config.lsp.keymaps").on_attach(client, buffer)
end)

Config.lsp.setup()

Config.lsp.on_dynamic_capability(require("config.lsp.keymaps").on_attach)

-- Set up diagnostics
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = {
		current_line = true,
	},
	-- TODO: add icons?
})

-- Set up inlay hints
Config.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
	if
		vim.api.nvim_buf_is_valid(buffer)
		and vim.bo[buffer].buftype == ""
		and not vim.tbl_contains({ "vue" }, vim.bo[buffer].filetype)
	then
		vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
	end
end)

-- TODO: Set up codelens
-- Config.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
-- 	vim.lsp.codelens.refresh()
-- 	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
-- 		buffer = buffer,
-- 		callback = vim.lsp.codelens.refresh,
-- 	})
-- end)

-- Enable LSPs
vim.lsp.enable(servers)
