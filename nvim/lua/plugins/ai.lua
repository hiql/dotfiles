return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = {
			provider = "ollama",
			ollama = {
				endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
				model = "phi3.5:latest",
			},
		},
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"MunifTanjim/nui.nvim",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "Avante" },
				},
				ft = { "Avante" },
			},
		},
	},
}
