---@brief
---
--- https://github.com/yioneko/vtsls

---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },

	init_options = {
		hostInfo = "neovim",
	},

	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},

	root_dir = function(bufnr, on_dir)
		-- Skip activation in Deno projects
		local deno_dir = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		if deno_dir then
			return
		end

		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers =
			{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = { root_markers, { ".git" } }

		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		on_dir(project_root)
	end,

	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},

	keys = {
		{
			"gD",
			function()
				local params = vim.lsp.util.make_position_params()
				Config.lsp.execute({
					command = "typescript.goToSourceDefinition",
					arguments = { params.textDocument.uri, params.position },
					open = true,
				})
			end,
			desc = "Goto Source Definition",
		},
		-- {
		-- 	"gR",
		-- 	function()
		-- 		Config.lsp.execute({
		-- 			command = "typescript.findAllFileReferences",
		-- 			arguments = { vim.uri_from_bufnr(0) },
		-- 			open = true,
		-- 		})
		-- 	end,
		-- 	desc = "File References",
		-- },
		{
			"<leader>co",
			Config.lsp.action["source.organizeImports"],
			desc = "Organize Imports",
		},
		{
			"<leader>cM",
			Config.lsp.action["source.addMissingImports.ts"],
			desc = "Add missing imports",
		},
		{
			"<leader>cu",
			Config.lsp.action["source.removeUnused.ts"],
			desc = "Remove unused imports",
		},
		{
			"<leader>cD",
			Config.lsp.action["source.fixAll.ts"],
			desc = "Fix all diagnostics",
		},
		{
			"<leader>cV",
			function()
				Config.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
			end,
			desc = "Select TS workspace version",
		},
	},

	on_attach = function()
		if vim.lsp.config.denols and vim.lsp.config.vtsls then
			---@param server string
			local resolve = function(server)
				local markers, root_dir =
					vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
				vim.lsp.config(server, {
					root_dir = function(bufnr, on_dir)
						local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
						if is_deno == (server == "denols") then
							if root_dir then
								return root_dir(bufnr, on_dir)
							elseif type(markers) == "table" then
								local root = vim.fs.root(bufnr, markers)
								return root and on_dir(root)
							end
						end
					end,
				})
			end
			resolve("denols")
			resolve("vtsls")
		end

		Config.lsp.on_attach(function(client, buffer)
			client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
				---@type string, string, lsp.Range
				local action, uri, range = unpack(command.arguments)

				local function move(newf)
					client:request("workspace/executeCommand", {
						command = command.command,
						arguments = { action, uri, range, newf },
					})
				end

				local fname = vim.uri_to_fname(uri)
				client:request("workspace/executeCommand", {
					command = "typescript.tsserverRequest",
					arguments = {
						"getMoveToRefactoringFileSuggestions",
						{
							file = fname,
							startLine = range.start.line + 1,
							startOffset = range.start.character + 1,
							endLine = range["end"].line + 1,
							endOffset = range["end"].character + 1,
						},
					},
				}, function(_, result)
					---@type string[]
					local files = result.body.files
					table.insert(files, 1, "Enter new path...")
					vim.ui.select(files, {
						prompt = "Select move destination:",
						format_item = function(f)
							return vim.fn.fnamemodify(f, ":~:.")
						end,
					}, function(f)
						if f and f:find("^Enter new path") then
							vim.ui.input({
								prompt = "Enter move destination:",
								default = vim.fn.fnamemodify(fname, ":h") .. "/",
								completion = "file",
							}, function(newf)
								return newf and move(newf)
							end)
						elseif f then
							move(f)
						end
					end)
				end)
			end
		end, "vtsls")

		require("lz.n").trigger_load("ts-error-translator-nvim")
	end,
}
