local cold_players = {}

local dstep = 0
minetest.register_globalstep(function(dtime)
	dstep = dstep + dtime

	if dstep <= 3 or not ctf_map.map then
		return
	end

	local COLD_START_HEIGHT = ctf_map.map.h / 2 - 10
	dstep = 0

	for _, player in pairs(minetest.get_connected_players()) do
		local pos = player:get_pos()

		if pos.y >= COLD_START_HEIGHT then
			local name = player:get_player_name()

			if not cold_players[name] then
				cold_players[name] = player:hud_add({
					hud_elem_type = "text",
					position = {x=0.5, y=0.3},
					name = "_hud",
					scale = {x=200, y=200},
					text = "You are cold. Get to a lower elevation before you freeze!",
					number = 0x2b9ae6,
					direction = 1,
					alignment = {x=0, y=0},
					offset = {x=0, y=0},
				})
			end

			player:set_hp(player:get_hp() - 1)
		end
	end

	for name, hudkey in pairs(cold_players) do
		local player = minetest.get_player_by_name(name)

		if not player then
			cold_players[name] = nil
		end

		if player:get_pos().y <= COLD_START_HEIGHT then
			player:hud_remove(hudkey)
			cold_players[name] = nil
		end
	end
end)
