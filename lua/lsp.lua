return {
	{
		"mason-org/mason.nvim",
		opt = {},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"creativenull/efmls-configs-nvim",
		},
		config = function()
			-- AutoCMD
			local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

			-- Format on save (ONLY real file buffers, ONLY when efm is attached)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				pattern = {
					"*.lua",
					"*.py",
					"*.go",
					"*.js",
					"*.jsx",
					"*.ts",
					"*.tsx",
					"*.json",
					"*.css",
					"*.scss",
					"*.html",
					"*.sh",
					"*.bash",
					"*.zsh",
					"*.c",
					"*.cpp",
					"*.h",
					"*.hpp",
				},
				callback = function(args)
					-- avoid formatting non-file buffers (helps prevent weird write prompts)
					if vim.bo[args.buf].buftype ~= "" then
						return
					end
					if not vim.bo[args.buf].modifiable then
						return
					end
					if vim.api.nvim_buf_get_name(args.buf) == "" then
						return
					end

					local has_efm = false
					for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
						if c.name == "efm" then
							has_efm = true
							break
						end
					end
					if not has_efm then
						return
					end

					pcall(vim.lsp.buf.format, {
						bufnr = args.buf,
						timeout_ms = 2000,
						filter = function(c)
							return c.name == "efm"
						end,
					})
				end,
			})

			-- highlight yanked text
			vim.api.nvim_create_autocmd("TextYankPost", {
				group = augroup,
				callback = function()
					vim.hl.on_yank()
				end,
			})

			-- return to last cursor position
			vim.api.nvim_create_autocmd("BufReadPost", {
				group = augroup,
				desc = "Restore last cursor position",
				callback = function()
					if vim.o.diff then -- except in diff mode
						return
					end

					local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
					local last_line = vim.api.nvim_buf_line_count(0)

					local row = last_pos[1]
					if row < 1 or row > last_line then
						return
					end

					pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
				end,
			})

			-- wrap, linebreak and spellcheck on markdown and text files
			vim.api.nvim_create_autocmd("FileType", {
				group = augroup,
				pattern = { "markdown", "text", "gitcommit" },
				callback = function()
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
					vim.opt_local.spell = true
				end,
			})

			local diagnostic_signs = {
				Error = " ",
				Warn = " ",
				Hint = "",
				Info = "",
			}

			vim.diagnostic.config({
				virtual_text = { prefix = "●", spacing = 4 },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
						[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
						[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
						[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
					focusable = false,
					style = "minimal",
				},
			})

			do
				local orig = vim.lsp.util.open_floating_preview
				function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
					opts = opts or {}
					opts.border = opts.border or "rounded"
					return orig(contents, syntax, opts, ...)
				end
			end

			local function lsp_on_attach(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				local bufnr = ev.buf
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "<leader>gd", function()
					require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
				end, opts)

				vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

				vim.keymap.set("n", "<leader>gS", function()
					vim.cmd("vsplit")
					vim.lsp.buf.definition()
				end, opts)

				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				vim.keymap.set("n", "<leader>D", function()
					vim.diagnostic.open_float({ scope = "line" })
				end, opts)
				vim.keymap.set("n", "<leader>d", function()
					vim.diagnostic.open_float({ scope = "cursor" })
				end, opts)
				vim.keymap.set("n", "<leader>nd", function()
					vim.diagnostic.jump({ count = 1 })
				end, opts)

				vim.keymap.set("n", "<leader>pd", function()
					vim.diagnostic.jump({ count = -1 })
				end, opts)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				vim.keymap.set("n", "<leader>fd", function()
					require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
				end, opts)
				vim.keymap.set("n", "<leader>fr", function()
					require("fzf-lua").lsp_references()
				end, opts)
				vim.keymap.set("n", "<leader>ft", function()
					require("fzf-lua").lsp_typedefs()
				end, opts)
				vim.keymap.set("n", "<leader>fs", function()
					require("fzf-lua").lsp_document_symbols()
				end, opts)
				vim.keymap.set("n", "<leader>fw", function()
					require("fzf-lua").lsp_workspace_symbols()
				end, opts)
				vim.keymap.set("n", "<leader>fi", function()
					require("fzf-lua").lsp_implementations()
				end, opts)

				if client:supports_method("textDocument/codeAction", bufnr) then
					vim.keymap.set("n", "<leader>i", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" }, diagnostics = {} },
							apply = true,
							bufnr = bufnr,
						})
						vim.defer_fn(function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end, 50)
					end, opts)
				end
			end
			vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

			vim.keymap.set("n", "<leader>q", function()
				vim.diagnostic.setloclist({ open = true })
			end, { desc = "Open diagnostic list" })
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.config("pyright", {})
			vim.lsp.config("bashls", {})
			vim.lsp.config("ts_ls", {})
			vim.lsp.config("gopls", {})
			vim.lsp.config("clangd", {})
			vim.lsp.config("rust_analyzer", {})
			vim.lsp.config("sqls", {})
			vim.lsp.config("tailwindcss", {})
			do
				local luacheck = require("efmls-configs.linters.luacheck")
				local stylua = require("efmls-configs.formatters.stylua")

				local flake8 = require("efmls-configs.linters.flake8")
				local black = require("efmls-configs.formatters.black")

				local prettier_d = require("efmls-configs.formatters.prettier_d")
				local eslint_d = require("efmls-configs.linters.eslint_d")

				local fixjson = require("efmls-configs.formatters.fixjson")

				local shellcheck = require("efmls-configs.linters.shellcheck")
				local shfmt = require("efmls-configs.formatters.shfmt")

				local cpplint = require("efmls-configs.linters.cpplint")
				local clangfmt = require("efmls-configs.formatters.clang_format")

				local go_revive = require("efmls-configs.linters.go_revive")
				local gofumpt = require("efmls-configs.formatters.gofumpt")

				local sqlfluff = require("efmls-configs.linters.sqlfluff")
				local sqlfluffm = require("efmls-configs.formatters.sqlfluff")

				vim.lsp.config("efm", {
					filetypes = {
						"c",
						"cpp",
						"css",
						"go",
						"html",
						"javascript",
						"javascriptreact",
						"json",
						"jsonc",
						"lua",
						"markdown",
						"python",
						"sh",
						"typescript",
						"typescriptreact",
						"vue",
						"svelte",
						"sql",
					},
					init_options = { documentFormatting = true },
					settings = {
						languages = {
							c = { clangfmt, cpplint },
							go = { gofumpt, go_revive },
							cpp = { clangfmt, cpplint },
							css = { prettier_d },
							html = { prettier_d },
							javascript = { eslint_d, prettier_d },
							javascriptreact = { eslint_d, prettier_d },
							json = { eslint_d, fixjson },
							jsonc = { eslint_d, fixjson },
							lua = { luacheck, stylua },
							markdown = { prettier_d },
							python = { flake8, black },
							sh = { shellcheck, shfmt },
							typescript = { eslint_d, prettier_d },
							typescriptreact = { eslint_d, prettier_d },
							vue = { eslint_d, prettier_d },
							svelte = { eslint_d, prettier_d },
							sql = { sqlfluff, sqlfluffm },
						},
					},
				})
			end

			vim.lsp.enable({
				"lua_ls",
				"pyright",
				"bashls",
				"ts_ls",
				"gopls",
				"clangd",
				"efm",
				"rust_analyzer",
				"sqls",
				"tailwindcss",
			})
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
			}
		end,
	},
	-- CMP
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = { menu = { auto_show = true } },

			snippets = {
				preset = "luasnip",
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
			},
			-- ensure you have the `snippets` source (enabled by default)
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = {
				implementation = "prefer_rust",
				prebuilt_binaries = { download = true },
			},
		},
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
