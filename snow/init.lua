ctf_match.register_on_new_match(function()
	minetest.add_particlespawner{
		amount = 100,
		time = 0,
		minpos = vector.new(ctf_map.map.pos1.x, ctf_map.map.h/2 - 1, ctf_map.map.pos1.z),
		maxpos = vector.new(ctf_map.map.pos2.x, ctf_map.map.h/2 - 1, ctf_map.map.pos2.z),
		minvel = {x=0, y=-10, z=0},
		maxvel = {x=0, y=-15, z=0},
		minacc = {x=0, y=0, z=0},
		maxacc = {x=0, y=0, z=0},
		minexptime = 10,
		maxexptime = 15,
		minsize = 3,
		maxsize = 5,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		vertical = false,
		texture = "snow_snowflake.png",
		glow = 1
	}
end)
