local particlespawner

ctf_match.register_on_new_match(function()
	if particlespawner ~= nil then
		minetest.delete_particlespawner(particlespawner)
	end

	particlespawner = minetest.add_particlespawner{
		amount = math.random(35, 70),
		time = 0,
		minpos = vector.new(ctf_map.map.pos1.x, ctf_map.map.h / 2 - 1, ctf_map.map.pos1.z),
		maxpos = vector.new(ctf_map.map.pos2.x, ctf_map.map.h / 2 - 1, ctf_map.map.pos2.z),
		minvel = {x = 0, y = -10, z = 0},
		maxvel = {x = 0, y = -15, z = 0},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 9,
		maxexptime = 10,
		minsize = 4,
		maxsize = 6,
		collisiondetection = false,
		vertical = false,
		texture = "snow_snowflake.png",
		glow = 0
	}
end)
