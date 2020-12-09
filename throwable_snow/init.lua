grenades.register_grenade("throwable_snow:snowball", {
	description = "Snowball",
	image = "default_snowball.png", -- The name of the grenade's texture
	range = 4,
	stack_max = 999,
	on_explode = function(pos, name)
		minetest.add_particlespawner({
			amount = 25,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = {x = -2, y = -1, z = -2},
			maxvel = {x = 2, y = 3, z = 2},
			minacc = {x = -1, y = -2, z = -1},
			maxacc = {x = 1, y = -4, z = 1},
			minexptime = 1,
			maxexptime = 2,
			minsize = 1,
			maxsize = 2,
			collisiondetection = true,
			collision_removal = true,
			vertical = false,
			texture = "default_snow.png",
		})

		minetest.sound_play("default_snow_footstep", {
			pos = pos,
			gain = 0.5,
			pitch = 3.0,
			max_hear_distance = 16,
		})
	end,
	on_collide = function(obj, name)
		return true
	end,
	particle = {
		image = "default_snow.png",
		life = 1,
		size = 1,
		glow = 1,
		interval = 0.5,
	}
})

minetest.override_item("default:snow", {drop = "throwable_snow:snowball"})
