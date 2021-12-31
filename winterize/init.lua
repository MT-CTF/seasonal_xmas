if os.date("%m") ~= "12" then return end

local snowy_dirt_tiles = minetest.registered_nodes["default:dirt_with_snow"].tiles
local snowy_dirt_sounds = minetest.registered_nodes["default:dirt_with_snow"].sounds
local grasses = {"dry_grass", "grass", "coniferous_litter",}
local leaves = {"leaves", "aspen_leaves", "jungleleaves"}


local snow_placement_blacklist = {"default:snow", ".*slab.*", ".*stair.*", ".*fence.*", ".*post.*", ".*door.*"}

local ice_sounds = default.node_sound_glass_defaults()
minetest.register_node("winterize:ice", { -- breaks instantly, drops nothing
	drawtype = "nodebox",
	description = "Ice",
	tiles = {"winterize_ice_seethrough.png"},
	buildable_to = true,
	floodable = true,
	paramtype = "light",
	sunlight_propagates = true,
	use_texture_alpha = "clip",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		},
	},
	drop = "",
	groups = {dig_immediate = 3, slippery = 4},
	sounds = ice_sounds,
})

local ice_fall_damage = 2
minetest.register_on_player_hpchange(function(player, hp_change, reason)
	if reason.type ~= "fall" then
		return hp_change
	end
	local pos = player:get_pos()
	local collision_box = player:get_properties().collisionbox
	-- Remove all ice nodes the collision box presumably collided with
	-- Only works for collision boxes where the XZ plane is smaller than 1x1
	for y = 0, -10, -1 do -- HACK arbitrarily look down up to 10 nodes, as clients tend to report fall damage early
		local ground_reached, ground_is_only_ice = false, true
		for x = 1, 4, 3 do
			for z = 3, 6, 3 do
				local node_pos = vector.offset(pos, collision_box[x], y, collision_box[z])
				local node = minetest.get_node(node_pos)
				if node.name == "winterize:ice" then
					ground_reached = true
					minetest.dig_node(node_pos)
					minetest.sound_play(ice_sounds.dig, {pos = node_pos}, true)
				elseif (minetest.registered_nodes[node.name] or {}).walkable ~= false then
					ground_reached = true
					ground_is_only_ice = false
				end
			end
		end
		if ground_reached then
			if ground_is_only_ice and hp_change < -ice_fall_damage then
				-- Infer speed from damage: "1 hp per node/s", 1.4 node/s base speed that goes without damage according to clientenvironment.cpp
				-- Continue falling with the speed only reduced by the done ice fall damage
				player:add_velocity(vector.new(0, ice_fall_damage - 1.4 + hp_change, 0))
				return -ice_fall_damage
			end
			return hp_change
		end
	end
end, true)

-- local function snow_can_fall_freely(pos)
-- 	local voxelmanip = VoxelManip()
-- 	local aircheck_pos = vector.new(pos.x, pos.y + 20, pos.z)
-- 	local vpos1, vpos2 = voxelmanip:read_from_map(pos, aircheck_pos)
-- 	local voxelarea = VoxelArea:new{MinEdge=vpos1, MaxEdge=vpos2}
-- 	local nodes_above = voxelmanip:get_data()

-- 	for ypos = pos.y, aircheck_pos.y, 1 do
-- 		local nodeid = nodes_above[voxelarea:indexp(vector.new(pos.x, ypos, pos.z))]
-- 		if nodeid ~= minetest.CONTENT_AIR and
-- 		minetest.registered_items[minetest.get_name_from_content_id(nodeid)].pointable then -- ignore barriers
-- 			return false -- Obstruction found
-- 		end
-- 	end

-- 	return true -- Snow can fall freely
-- end

-- local function snow_can_fall_freely(pos)
-- 	return not minetest.raycast(pos, vector.new(pos.x, pos.y+5, pos.z), false, true):next()
-- end

local get_node = minetest.get_node
local set_node = minetest.set_node
minetest.register_lbm({
	label = "Add ice layer to top of water",
	name = "winterize:top_water_with_ice",
	nodenames = {"default:water_source", "default:river_water_source"},
	run_at_every_load = true,
	action = function(pos, node)
		local pos_above = vector.new(pos.x, pos.y + 1, pos.z)

		if minetest.get_node(pos_above).name == "air" then
			minetest.set_node(pos_above, {name = "winterize:ice"})
		end
	end
})

local match = string.match
local registered_items = minetest.registered_items
local random = math.random
minetest.register_lbm({
	label = "Place snow on top of nodes",
	name = "winterize:top_nodes_with_snow",
	nodenames = {"group:crumbly", "group:leaves", "group:choppy"},
	run_at_every_load = true,
	action = function(pos, node)
		if node.name == "air" or random(1, 20) ~= 1 then return end

		local pos_above = {x = pos.x, y = pos.y + 1, z = pos.z}

		for _, searchfor in pairs(snow_placement_blacklist) do
			if match(node.name, searchfor) then
				return
			end
		end

		if get_node(pos_above).name == "air" and registered_items[node.name].walkable then
			-- if snow_can_fall_freely(pos_above) then
				set_node(pos_above, {name = "default:snow"})
			-- end
		end
	end
})

local function get_drop(original, rarity)
	return {
		items = {
			{
				items = {original},
			},
			{
				rarity = rarity,
				items = {"throwable_snow:snowball"},
			},
		}
	}
end

for _, leaftype in pairs(leaves) do
	minetest.override_item("default:" .. leaftype, {
		tiles = {"winterize_dead_leaves.png"},
		special_tiles = {"winterize_dead_leaves.png"},
	})

	minetest.override_item("ctf_map:" .. leaftype, {
		tiles = {"winterize_dead_leaves.png"},
		special_tiles = {"winterize_dead_leaves.png"},
	})
end

for _, grasstype in pairs(grasses) do
	minetest.override_item("default:dirt_with_" .. grasstype, {
		tiles = snowy_dirt_tiles,
		sounds = snowy_dirt_sounds,
		drop = get_drop("default:dirt", 3),
	})

	if minetest.registered_nodes["ctf_map:dirt_with_" .. grasstype] then
		minetest.override_item("ctf_map:dirt_with_" .. grasstype, {
			tiles = snowy_dirt_tiles,
			sounds = snowy_dirt_sounds,
		})
	end
end

minetest.override_item("default:snowblock", {
	drop = get_drop("default:snowblock", 2)
})
