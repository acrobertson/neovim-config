---@brief
---
--- https://github.com/kaermorchen/twig-language-server

---@type vim.lsp.Config
return {
	cmd = { "twig-language-server", "--stdio" },
	filetypes = { "twig" },
	root_markers = { "composer.json", ".git" },
}
