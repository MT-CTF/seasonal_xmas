if os.date("%m") ~= "12" then return end

ctf_map.register_maps_dir(minetest.get_modpath(minetest.get_current_modname()).."/maps/")

local old_select_map_for_mode = ctf_modebase.map_catalog.select_map_for_mode
local was_last = false
local first_map = true
function ctf_modebase.map_catalog.select_map_for_mode(mode, ...)
	if first_map or (
		math.random(1, 10) == 2 and
		not was_last and
		tonumber(os.date("%d")) >= 11 and tonumber(os.date("%d")) <= 25 -- Enable extra during the hat event
	) then
		was_last = true
		first_map = false

		ctf_modebase.map_catalog.select_map(function(map)
			return map.dirname == "snow_globe"
		end, true)
	else
		was_last = false
		old_select_map_for_mode(mode, ...)
	end
end