return {
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {},
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},

	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = {
					winblend = vim.o.pumblend,
				},
			},
			signature = {
				window = {
					winblend = vim.o.pumblend,
				},
			},
		},
	},
}
