-- General utililty functions and handlers to use within neovim.
--
-- Functions:
--    -> run_cmd
--    -> get_icon

local M = {}

function M.get_icon(icon_name, fallback)
	if fallback and vim.g.fallback_icons_enabled then return "" end -- Guard clause
	local icon_pack = (vim.g.fallback_icons_enabled and "fallback_icons") or "icons"
	-- Cache icon pack into the module only if not already cached
	if not M[icon_pack] then
		if icon_pack == "icons" then
			M.icons = require("base.icons.icons")
		elseif icon_pack == "fallback_icons" then
			M.fallback_icons = require("base.icons.fallback_icons)
		end
	end
	-- Return the specified icon
	local icon = M[icon_pack] and M[icon_pack][icon_name]
	return icon
end
	
