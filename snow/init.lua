local particlespawners = {}

local function attach_snow_spawner(player)
	local name = player:get_player_name()

	if particlespawners[name] ~= nil then
		minetest.delete_particlespawner(particlespawners[name])
	end

	particlespawners[name] = minetest.add_particlespawner{
		amount = math.random(50, 100),
		time = 0,
		minpos = vector.new(-50, 20, -50),
		maxpos = vector.new(50, 25, 50),
		minvel = {x = 0, y = -10, z = 0},
		maxvel = {x = 0, y = -15, z = 0},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 9,
		maxexptime = 10,
		minsize = 1,
		maxsize = 4,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		vertical = false,
		playername = name,
		attached = player,
		texture = "snow_snowflake.png",
		glow = 0
	}
end

ctf_match.register_on_new_match(function() -- Attach snow spawner to all online players
	minetest.after(5, function()
		for _, player in pairs(minetest.get_connected_players()) do
			attach_snow_spawner(player)
		end
	end)
end)

minetest.register_on_joinplayer(function(player) -- Attach snow spawner to player
	attach_snow_spawner(player)
end)

minetest.register_on_leaveplayer(function(player) -- Remove player's soon-to-be-unused snow spawner
	local name = player:get_player_name()

	minetest.delete_particlespawner(particlespawners[name])
	particlespawners[name] = nil
end)
