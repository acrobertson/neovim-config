---@brief
---
--- https://github.com/olrtg/emmet-language-server

---@type vim.lsp.Config
return {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = {
		"astro",
		"css",
		"eruby",
		"heex",
		"html",
		"htmlangular",
		"htmldjango",
		"javascript",
		"javascriptreact",
		"less",
		"php",
		"pug",
		"sass",
		"scss",
		"svelte",
		"templ",
		"twig",
		"typescriptreact",
		"vue",
	},
	root_markers = { ".git" },
}
