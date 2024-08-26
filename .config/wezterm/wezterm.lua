-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

local function font(opts)
    return wezterm.font_with_fallback({
        opts,
        { family = "CommitMono Nerd Font Mono" },
    })
end

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
-- config.default_prog = { "/usr/local/bin/fish", "-l" }
config.font = font({ family = "JetBrainsMono Nerd Font Mono" })
config.font_size = 13.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.initial_cols = 180
config.initial_rows = 48
config.window_decorations = "TITLE|RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.adjust_window_size_when_changing_font_size = false
config.enable_scroll_bar = false
config.scrollback_lines = 50000
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false
config.command_palette_font_size = 14
config.command_palette_bg_color = "#1e2030"
config.color_scheme = "Catppuccin Macchiato"
config.bold_brightens_ansi_colors = true
config.colors = {
    tab_bar = {
        background = "none",
    },
}

-- keymaps

config.disable_default_key_bindings = true
-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
local keymaps = {
    { key = "N",          mods = "SHIFT|CMD", action = act.SpawnWindow },
    { key = "[",          mods = "CMD",       action = act.ActivateTabRelative(-1) },
    { key = "]",          mods = "CMD",       action = act.ActivateTabRelative(1) },
    { key = "1",          mods = "CMD",       action = act.ActivateTab(0) },
    { key = "2",          mods = "CMD",       action = act.ActivateTab(1) },
    { key = "3",          mods = "CMD",       action = act.ActivateTab(2) },
    { key = "4",          mods = "CMD",       action = act.ActivateTab(3) },
    { key = "5",          mods = "CMD",       action = act.ActivateTab(4) },
    { key = "6",          mods = "CMD",       action = act.ActivateTab(5) },
    { key = "7",          mods = "CMD",       action = act.ActivateTab(6) },
    { key = "8",          mods = "CMD",       action = act.ActivateTab(7) },
    { key = "9",          mods = "CMD",       action = act.ActivateTab(-1) },
    { key = "t",          mods = "CMD",       action = act.SpawnTab("CurrentPaneDomain") },
    { key = "o",          mods = "CMD",       action = act.ActivateLastTab },
    { key = "w",          mods = "CMD",       action = act.CloseCurrentTab({ confirm = true }) },
    { key = "Z",          mods = "SHIFT|CMD", action = act.TogglePaneZoomState },
    { key = "n",          mods = "CMD",       action = act.ShowTabNavigator },
    { key = "c",          mods = "CMD",       action = act.CopyTo("Clipboard") },
    { key = "v",          mods = "CMD",       action = act.PasteFrom("Clipboard") },
    { key = "x",          mods = "CMD",       action = act.ActivateCopyMode },
    { key = "_",          mods = "SHIFT|CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "|",          mods = "SHIFT|CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "f",          mods = "CMD",       action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "k",          mods = "CMD",       action = act.ClearScrollback("ScrollbackOnly") },
    { key = "p",          mods = "CMD",       action = act.PaneSelect({ alphabet = "", mode = "Activate" }) },
    { key = "e",          mods = "CMD",       action = act.CloseCurrentPane({ confirm = true }) },
    -- { key = 'r',          mods = 'CMD',       action = act.RotatePanes("Clockwise") },
    { key = "q",          mods = "CMD",       action = act.QuitApplication },
    { key = "R",          mods = "SHIFT|CMD", action = act.ReloadConfiguration },
    { key = "P",          mods = "SHIFT|CMD", action = act.ActivateCommandPalette },
    { key = "L",          mods = "SHIFT|CMD", action = act.ShowDebugOverlay },
    { key = "phys:Space", mods = "SHIFT|CMD", action = act.QuickSelect },
    {
        key = "U",
        mods = "SHIFT|CMD",
        action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    -- Launcher
    {
        mods = "SHIFT|CMD",
        key = "Backspace",
        action = act.ShowLauncherArgs({
            flags = "FUZZY|WORKSPACES|TABS|LAUNCH_MENU_ITEMS",
        }),
    },
    -- resize window
    {
        key = "m",
        mods = "CMD",
        action = wezterm.action_callback(function(window, _, _)
            window:maximize()
        end),
    },
    {
        key = "M",
        mods = "SHIFT|CMD",
        action = wezterm.action_callback(function(window, _, _)
            window:restore()
        end),
    },
    -- Rename tab
    {
        key = "T",
        mods = "SHIFT|CMD",
        action = act.PromptInputLine({
            description = "Enter new name for tab",
            action = wezterm.action_callback(function(window, _pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
    -- Rename workspace
    {
        key = "W",
        mods = "SHIFT|CMD",
        action = act.PromptInputLine({
            description = "Enter new name for workspace",
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
                end
            end),
        }),
    },
    -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
    -- mode until we cancel that mode.
    {
        key = "r",
        mods = "CMD",
        action = act.ActivateKeyTable({
            name = "resize_pane",
            one_shot = false,
        }),
    },
    -- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
    -- mode until we press some other key or until 1 second (1000ms)
    -- of time elapses
    {
        key = "a",
        mods = "CMD",
        action = act.ActivateKeyTable({
            name = "activate_pane",
            timeout_milliseconds = 1000,
        }),
    },
}

config.keys = keymaps

config.key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
        { key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "h",          action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "l",          action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "k",          action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },
        { key = "j",          action = act.AdjustPaneSize({ "Down", 1 }) },
        -- Cancel the mode by pressing escape
        { key = "Escape",     action = "PopKeyTable" },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
        { key = "LeftArrow",  action = act.ActivatePaneDirection("Left") },
        { key = "h",          action = act.ActivatePaneDirection("Left") },
        { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
        { key = "l",          action = act.ActivatePaneDirection("Right") },
        { key = "UpArrow",    action = act.ActivatePaneDirection("Up") },
        { key = "k",          action = act.ActivatePaneDirection("Up") },
        { key = "DownArrow",  action = act.ActivatePaneDirection("Down") },
        { key = "j",          action = act.ActivatePaneDirection("Down") },
    },
}

config.hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
        regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
        format = "$0",
    },
    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
        regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
        format = "mailto:$0",
    },
    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
        regex = [[\bfile://\S*\b]],
        format = "$0",
    },
    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
        regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
        format = "$0",
    },
    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    {
        regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
        format = "https://www.github.com/$1/$3",
    },
}

-- Events

-- Trim a string
local function trim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

-- Run a command, return the output.
local function run(cmd)
    local _, stdout, stderr = wezterm.run_child_process(cmd)
    local out
    if stdout and stderr then
        out = stdout .. " " .. stderr
    elseif stdout then
        out = stdout
    else
        out = stderr
    end
    return trim(out)
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)
local SOLID_RIGHT_REV_ARROW = utf8.char(0xe0d7)
local SOFT_RIGHT_ARROW = utf8.char(0xe0b1)
local TERMINAL_ICON = utf8.char(0xf120)
local USER_ACCOUNT = utf8.char(0xf007)
local CLOCK_ICON = utf8.char(0xf43a)
local ZOOM_IN_ICON = utf8.char(0xf50c)

local TAB_BAR_BG = "#30354f"
local TAB_BAR_FG = "#8aadf4"
local ACTIVE_TAB_BG = "#7dc4e4"
local ACTIVE_TAB_FG = "Black"
local HOVER_TAB_BG = "#91d7e3"
local HOVER_TAB_FG = "#363a4f"
local NORMAL_TAB_BG = "#363a4f"
local NORMAL_TAB_FG = "#b8c0e0"
local NORMAL_TAB_INDEX_FG = "#ed8796"
local ACTIVE_TAB_INDEX_FG = "#7c4dff"
local NORMAL_MUTE_FG = "#6e738d"
local ACTIVE_MUTE_FG = "#363a4f"

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    panes = panes
    config = config
    max_width = max_width

    local is_first = tab.tab_id == tabs[1].tab_id
    local is_last = tab.tab_id == tabs[#tabs].tab_id
    local title = tab_title(tab)
    local tab_index = tab.is_active and tab.tab_index + 1 or tab.tab_index + 1

    local mute_fg = NORMAL_MUTE_FG
    local background = NORMAL_TAB_BG
    local foreground = NORMAL_TAB_FG
    local leading_fg = NORMAL_TAB_BG
    local leading_bg = "none"
    local trailing_fg = NORMAL_TAB_BG
    local trailing_bg = "none"
    local tab_idx_fg = NORMAL_TAB_INDEX_FG
    local tab_idx_left = " ❬"
    local tab_idx_right = "❭ "
    local tab_idx = tab_index .. ""

    if tab.is_active then
        background = ACTIVE_TAB_BG
        foreground = ACTIVE_TAB_FG
        leading_bg = "none"
        leading_fg = ACTIVE_TAB_BG
        trailing_bg = "none"
        trailing_fg = ACTIVE_TAB_BG
        tab_idx_fg = ACTIVE_TAB_INDEX_FG
        mute_fg = ACTIVE_MUTE_FG
        -- tab_idx_left = " ["
        -- tab_idx_right = "] "
        -- tab_idx = TERMINAL_ICON
    elseif hover then
        background = HOVER_TAB_BG
        foreground = HOVER_TAB_FG
        leading_bg = "none"
        leading_fg = HOVER_TAB_BG
        trailing_bg = "none"
        trailing_fg = HOVER_TAB_BG
    end

    local zoomed = ""
    if tab.active_pane.is_zoomed then
        zoomed = ZOOM_IN_ICON .. " "
    end

    if string.len(title) > max_width - 6 then
        title = wezterm.truncate_right(title, max_width - 10) .. " ⋯"
    end

    return {
        { Background = { Color = leading_bg } },
        { Foreground = { Color = leading_fg } },
        { Text = SOLID_RIGHT_REV_ARROW },
        { Attribute = { Italic = false } },
        { Attribute = { Intensity = (hover or tab.is_active) and "Bold" or "Normal" } },
        { Background = { Color = background } },
        { Foreground = { Color = mute_fg } },
        { Text = tab_idx_left },
        { Foreground = { Color = tab_idx_fg } },
        { Text = tab_idx },
        { Foreground = { Color = mute_fg } },
        { Text = tab_idx_right },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title .. " " .. zoomed },
        { Background = { Color = trailing_bg } },
        { Foreground = { Color = trailing_fg } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)

wezterm.on("update-status", function(window, pane)
    local cells = {}

    -- local active_workspace = window:active_workspace()
    -- local workspace = wezterm.format({
    -- 	{ Text = utf8.char("0xeb44") .. " " .. active_workspace },
    -- })
    -- table.insert(cells, workspace)

    -- local cpu_temp = run({ wezterm.home_dir .. "/bin/smctemp", "-c", "-i25", "-n180", "-f" })
    -- local gpu_temp = run({ wezterm.home_dir .. "/bin/smctemp", "-g", "-i25", "-n180", "-f" })
    -- local temp_str = wezterm.format({
    -- 	{ Text = "temp:" .. cpu_temp .. "," .. gpu_temp },
    -- })
    -- table.insert(cells, temp_str)

    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
    local date_str = wezterm.format({
        { Text = date },
    })
    table.insert(cells, date_str)

    if window:leader_is_active() then
        local leader = "LEADER"
        table.insert(cells, leader)
    end

    local active_key_table = window:active_key_table()
    local mode = wezterm.format({
        { Text = active_key_table or "" },
    })
    if active_key_table then
        table.insert(cells, mode)
    end

    -- Color palette for the backgrounds of each cell
    local colors = {
        "#8aadf4",
        "#f38ca9",
        "#d57c95",
        "#b86c81",
    }
    -- Foreground color for the text across the fade
    local text_fg = "#24273a"

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    local function push(text, is_last)
        local cell_no = num_cells + 1
        if cell_no == 1 then
            table.insert(elements, { Foreground = { Color = colors[cell_no] } })
            table.insert(elements, { Text = SOLID_LEFT_ARROW })
        end
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Background = { Color = colors[cell_no] } })
        table.insert(elements, { Text = " " .. text .. " " })
        if not is_last then
            table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
            table.insert(elements, { Text = SOLID_LEFT_ARROW })
        end
        num_cells = num_cells + 1
    end

    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0)
    end

    window:set_right_status(wezterm.format(elements))

    local username = os.getenv("USER") or os.getenv("LOGNAME") or os.getenv("USERNAME")
    local hostname = wezterm.hostname()
    -- Remove the domain name portion of the hostname
    local dot = hostname:find("[.]")
    if dot then
        hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
        hostname = wezterm.hostname()
    end

    window:set_left_status(wezterm.format({
        -- { Background = { Color = TAB_BAR_BG } },
        -- { Foreground = { Color = TAB_BAR_FG } },

        { Background = { Color = "#c6a0f6" } },
        { Foreground = { Color = TAB_BAR_BG } },
        { Text = " " .. USER_ACCOUNT .. " " .. username .. "@" .. hostname .. " " },
        { Background = { Color = "none" } },
        { Foreground = { Color = "#c6a0f6" } },
        { Text = SOLID_RIGHT_ARROW },
    }))
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
    return "Dev As Life"
end)

wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
    if default_action and button == "Left" then
        window:perform_action(default_action, pane)
    end

    if default_action and button == "Right" then
        window:perform_action(
            wezterm.action.ShowLauncherArgs({
                title = wezterm.nerdfonts.fa_rocket .. "  Select/Search:",
                flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS",
            }),
            pane
        )
    end
    return false
end)

-- Neovim Zen Mode Integration
wezterm.on("user-var-changed", function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while number_value > 0 do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("window-config-reloaded", function(window, pane)
    window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

-- and finally, return the configuration to wezterm
return config
