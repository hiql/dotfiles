local M = {}

M._hex_to_rgb = function(hex)
	hex = hex:gsub("#", "")
	return {
		r = tonumber(hex:sub(1, 2), 16) / 255,
		g = tonumber(hex:sub(3, 4), 16) / 255,
		b = tonumber(hex:sub(5, 6), 16) / 255,
	}
end

M._relative_luminance = function(color)
	local r, g, b = color.r, color.g, color.b
	local function adjust(channel)
		if channel <= 0.03928 then
			return channel / 12.92
		else
			return ((channel + 0.055) / 1.055) ^ 2.4
		end
	end
	r, g, b = adjust(r), adjust(g), adjust(b)
	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

M.contrast_color = function(bg_hex)
	local bg_color = M._hex_to_rgb(bg_hex)
	local bg_luminance = M._relative_luminance(bg_color)
	-- The W3C recommendation states that if the relative luminance
	-- is more than 0.179, the text should be black; otherwise, it should be white.
	if bg_luminance > 0.179 then
		return "black"
	else
		return "white"
	end
end

return M
