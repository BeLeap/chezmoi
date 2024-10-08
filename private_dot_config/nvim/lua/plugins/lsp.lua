return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-path" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "path" },
				},
				formatting = lsp_zero.cmp_format(),
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
				}),
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.preset("recommended")

			require("mason-lspconfig").setup({
				-- ensure_installed = {
				-- 	"lua_ls",
				-- 	"tsserver",
				-- },
				handlers = {
					lsp_zero.default_setup,
				},
			})
			lsp_zero.configure("clangd", {})
			lsp_zero.configure("ts_ls", {
				single_file_support = false,
				root_dir = require("lspconfig.util").root_pattern("package.json"),
			})
			-- lsp_zero.configure('denols', {
			--   single_file_support = false,
			-- })
			lsp_zero.configure("nil_ls", {
				autostart = true,
				settings = {
					["nil"] = {
						testSetting = 42,
						formatting = {
							command = { "nixpkgs-fmt" },
						},
					},
				},
			})

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
				-- lsp_zero.buffer_autoformat()

				vim.keymap.set("n", "<leader>rn", function()
					vim.lsp.buf.rename()
				end, { buffer = bufnr })
				vim.keymap.set("n", "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, { buffer = bufnr })
				vim.keymap.set("n", "<leader>fo", function()
					vim.lsp.buf.format()
				end, { buffer = bufnr })
			end)

			lsp_zero.set_server_config({
				capabilities = {
					textDocument = {
						foldingRegistration = false,
						lineFoldingOnly = true,
					},
				},
			})

			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
			require("lspconfig").kotlin_language_server.setup({
				init_options = {
					storagePath = "~/.cache/nvim",
				},
			})

			lsp_zero.setup_servers({ "gopls", "dartls", "rescriptls" })
			lsp_zero.setup()
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = true,
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			-- options
		},
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.code_actions.gitsigns,
					null_ls.builtins.formatting.stylua,
					-- null_ls.builtins.formatting.prettier,
					null_ls.builtins.completion.spell,
				},
			})
		end,
	},
}
