return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		-- 'nvim-treesitter/nvim-treesitter-textobjects',
		-- 'HiPhish/rainbow-delimiters.nvim'
	},
	build = ':TSUpdate',
	config = function()
		require('nvim-treesitter.configs').setup {
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = { 'c', 'lua', 'vimdoc', 'vim', 'bash', 'markdown', 'markdown_inline', 'regex', 'yaml' },

			sync_install = false,
			auto_install = true,
			ignore_install = { '' },

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			modules = {}
		}
	end
}
