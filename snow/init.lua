if os.date("%m") ~= "12" then return end

-- Particlespawner attachment is currently broken, so the following code positions a
-- particle spawner which lasts for 1.4s every 0.7s for each player. The spawners are
-- bound to individual players

-- Set clouds
minetest.register_on_joinplayer(function(player)
	player:set_clouds({
		density = 0.7,
		color = "#aaaaaacc",
		height = 100,
		thickness = 20,
		speed = {x = -3, z = -3},
	})
end)

-- Spawns snow particles around player
local function spawn_particles(player)
	local pos = player:get_pos()
	minetest.add_particlespawner({
		amount = 40,
		minpos = vector.new(pos.x - 25, pos.y + 15, pos.z - 25),
		maxpos = vector.new(pos.x + 25, pos.y + 25, pos.z + 25),
		minvel = vector.new(-2, -7, -2),
		maxvel = vector.new(-2, -9, -2),
		time = 2,
		minexptime = 10,
		maxexptime = 10,
		minsize = 1,
		maxsize = 3,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		vertical = false,
		texture = ("[combine:7x7:%s,%s=snow_snowflakes.png"):format(math.random(0, 3) * -7, math.random(0, 1) * -7),
		playername = player:get_player_name(),
		glow = 1
	})
end

local spawner_step = 0
minetest.register_globalstep(function(dtime)
	spawner_step = spawner_step + dtime

	if spawner_step >= 2 then
		spawner_step = 0

		for _, player in pairs(minetest.get_connected_players()) do
			spawn_particles(player)
		end
	end
end)
