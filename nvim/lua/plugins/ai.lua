return {
    {
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		build = "make",
		opts = {
			provider = "ollama",
			vendors = {
				ollama = {
					api_key_name = "",
					endpoint = "http://127.0.0.1:11434/v1",
					model = "phi3:latest",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat/completions",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								messages = require("avante.providers").copilot.parse_messages(code_opts),
								max_tokens = 2048,
								stream = true,
							},
						}
					end,
					parse_response_data = function(data_stream, event_state, opts)
						require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
					end,
				},
			},
		},
		dependencies = {

			"stevearc/dressing.nvim",
			"MunifTanjim/nui.nvim",
			{
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
		},
	}
}
