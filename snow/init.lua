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
		amount = 35,
		minpos = vector.new(pos.x - 25, pos.y + 15, pos.z - 25),
		maxpos = vector.new(pos.x + 25, pos.y + 25, pos.z + 25),
		minvel = vector.new(-2, -5, -2),
		maxvel = vector.new(-2, -7, -2),
		time = 1.4,
		minexptime = 10,
		maxexptime = 10,
		minsize = 1,
		maxsize = 3,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		vertical = false,
		texture = "snow_snowflake" .. math.random(1, 15) .. ".png",
		playername = player:get_player_name(),
		glow = 0
	})
end

local spawner_step = 0
minetest.register_globalstep(function(dtime)
	spawner_step = spawner_step + dtime

	if spawner_step >= 0.7 then
		spawner_step = 0

		for _, player in pairs(minetest.get_connected_players()) do
			-- Spawn snow
			spawn_particles(player)

			-- Update sky (stolen from snowdrift https://github.com/paramat/snowdrift/blob/master/init.lua#L132-L151)
			local NISVAL = 10 -- Overcast sky RGB value at night (brightness)
			local DASVAL = 90 -- Overcast sky RGB value in daytime (brightness)
			local difsval = DASVAL - NISVAL
			local sval
			local time = minetest.get_timeofday()
			if time >= 0.5 then
				time = 1 - time
			end
			-- Sky brightness transitions:
			-- First transition (24000 -) 4500, (1 -) 0.1875
			-- Last transition (24000 -) 5750, (1 -) 0.2396
			if time <= 0.1875 then
				sval = NISVAL
			elseif time >= 0.2396 then
				sval = DASVAL
			else
				sval = math.floor(NISVAL +
					((time - 0.1875) / 0.0521) * difsval)
			end
			player:set_sky({r = sval - 8, g = sval, b = sval + 8, a = 255},	"plain", {}, true)
		end
	end
end)
