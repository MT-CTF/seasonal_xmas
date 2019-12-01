local function spawn_particle_inside_area(player, pos1, pos2) -- Spawns a particle inside the area defined by pos1/pos2
	minetest.add_particlespawner({
	    amount = 25,
		minpos = pos1,
		maxpos = pos2,
        minvel = vector.new(0, -10, 0),
        maxvel = vector.new(0, -15, 0),
        time = 1.4,
        minexptime = 10,
        maxexptime = 10,
        minsize = 3,
        maxsize = 5,
        collisiondetection = true,
        collision_removal = true,
        object_collision = true,
        vertical = false,
        texture = "snow_snowflake.png",
        playername = player:get_player_name(),
        glow = 0
	})
end

local function spawn_particles(player) -- Spawns snow particles around player
	local pos = player:get_pos()
	local pos1 = vector.new(pos.x - 20, pos.y + 15, pos.z - 20)
	local pos2 = vector.new(pos.x + 20, pos.y + 20, pos.z + 20)

    spawn_particle_inside_area(player, pos1, pos2)
end

local spawner_step = 0
minetest.register_globalstep(function(dtime)
	spawner_step = spawner_step + dtime

	if spawner_step >= 0.7 then
		spawner_step = 0

		for _, player in pairs(minetest.get_connected_players()) do
			spawn_particles(player)
		end
	end
end)
