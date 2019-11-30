local function spawn_particle_inside_area(player, pos1, pos2) -- Spawns a particle inside the area defined by pos1/pos2
	minetest.add_particle({
        pos = {
			x = math.random(pos1.x, pos2.x),
			y = math.random(pos1.y, pos2.y),
			z = math.random(pos1.z, pos2.z),
		},
        velocity = vector.new(0, math.random(-10, -15), 0),
        expirationtime = 10,
        size = math.random(3, 5),
        collisiondetection = true,
        collision_removal = true,
        object_collision = true,
        vertical = false,
        texture = "snow_snowflake.png",
        playername = player:get_player_name(),
        glow = 0
	})
end

local function spawn_particles(player) -- Spawns 7 snow particles around player
	local pos = player:get_pos()
	local pos1 = vector.new(pos.x - 20, pos.y + 15, pos.z - 20)
	local pos2 = vector.new(pos.x + 20, pos.y + 20, pos.z + 20)

	for i = 1, 7, 1 do
		spawn_particle_inside_area(player, pos1, pos2)
	end
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
