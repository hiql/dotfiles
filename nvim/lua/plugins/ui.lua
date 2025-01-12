return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
			opts.presets.inc_rename = true
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
		  vim.g.lualine_laststatus = vim.o.laststatus
		  if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		  else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		  end
		end,
		opts = function()
					
			-- Color table for highlights
			-- stylua: ignore
			local colors = {
				bg       = '#1e1e2e',
				fg       = '#bbc2cf',
				yellow   = '#ECBE7B',
				cyan     = '#008080',
				darkblue = '#081633',
				green    = '#98be65',
				orange   = '#FF8800',
				violet   = '#a9a1e1',
				magenta  = '#c678dd',
				blue     = '#51afef',
				red      = '#ec5f67',
			}

			local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand('%:p:h')
				local gitdir = vim.fn.finddir('.git', filepath .. ';')
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
			}

			-- Config
			local config = {
			options = {
				-- Disable sections and component separators
				component_separators = '',
				section_separators = '',
				theme = {
				-- We are going to use lualine_c an lualine_x as left and
				-- right section. Both are highlighted by c theme .  So we
				-- are just setting default looks o statusline
				normal = { c = { fg = colors.fg, bg = colors.bg } },
				inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x at right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left {
				function()
					return '▊'
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			}

			ins_left {
				-- mode component
				function()
					return ''
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[''] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[''] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					['r?'] = colors.cyan,
					['!'] = colors.red,
					t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			}

			-- ins_left {
			-- 	-- filesize component
			-- 	'filesize',
			-- 	cond = conditions.buffer_not_empty,
			-- }

			

			ins_left {
				'filename',
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = 'bold' },
			}



			ins_left {
				'diagnostics',
				sources = { 'nvim_diagnostic' },
				symbols = { error = ' ', warn = ' ', info = ' ' },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			}

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it's any number greater then 2
			ins_left {
				function()
					return '%='
				end,
			}


			-- -- Add components to right sections
			-- ins_right {
			-- 	'o:encoding', -- option component same as &encoding in viml
			-- 	fmt = string.upper, -- I'm not sure why it's upper case either ;)
			-- 	cond = conditions.hide_in_width,
			-- 	color = { fg = colors.green, gui = 'bold' },
			-- }

			-- ins_right {
			-- 	'fileformat',
			-- 	fmt = string.upper,
			-- 	icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
			-- 	color = { fg = colors.green, gui = 'bold' },
			-- }

			

			ins_right {
				'diff',
				-- Is it me or the symbol for modified us really weird
				symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			}

			ins_right {
				'branch',
				icon = '',
				color = { fg = colors.violet, gui = 'bold' },
			}

			ins_right { 'location' }
			ins_right { 'progress', color = { fg = colors.fg } }

			ins_right {
				function()
					return '▊'
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			}
 
		  	return config
		end,
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local helpers = require("incline.helpers")
			local devicons = require("nvim-web-devicons")
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guifg = "#181926", guibg = "#cba6f7", gui = "bold" },
						InclineNormalNC = { guibg = "#45475a", guifg = "#aeafb0" },
					},
				},
				window = {
					padding = 0,
					margin = { vertical = 0, horizontal = 0 },
					overlap = {
						borders = false,
						statusline = false,
						tabline = false,
						winbar = false,
					},
				},
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					if not props.focused then
						ft_color = "#313244"
					end
					local modified = vim.bo[props.buf].modified
					if modified then
						filename = "[+] " .. filename
					end
					local buffer = {
						ft_icon and {
							" ",
							ft_icon,
							" ",
							guibg = ft_color,
							guifg = helpers.contrast_color(ft_color),
						} or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "" },
						" ",
						guibg = "none",
					}
					return buffer
				end,
			})
		end,
	},

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			zen = {
				on_open = function()
					require("incline").disable()
				end,
				on_close = function()
					require("incline").enable()
				end,
			},
			dashboard = {
				preset = {
					header = [[
                   ,,
      __         o-°°|\_____/)
 (___()'`; NEOVIM \_/|_)     )
 /,    /`            \  __  /
 \\"--\\             (_/ (_/
 Talk is cheap, show me your code.
]],
				},
			},
			scroll = { enabled = true },
		},
	},
}
