local snowy_dirt_tiles = minetest.registered_nodes["default:dirt_with_snow"].tiles
local snowy_dirt_sounds = minetest.registered_nodes["default:dirt_with_snow"].sounds
local grasses = {"dry_grass", "grass", "coniferous_litter",}
local leaves = {"leaves", "aspen_leaves", "jungleleaves"}
local snow_placement_blacklist = {"default:snow", "slab", "stair", "fence"}

minetest.register_node("winterize:ice", { -- breaks instantly, drops nothing
	drawtype = "nodebox",
	description = "Ice",
	tiles = {"winterize_ice_seethrough.png"},
	buildable_to = true,
	floodable = true,
	paramtype = "light",
	sunlight_propogates = true,
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
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_lbm({
	label = "Add ice layer to top of water",
	name = "winterize:top_water_with_ice",
	nodenames = {"default:water_source"},
	run_at_every_load = true,
	action = function(pos, node)
		local pos_above = vector.new(pos.x, pos.y + 1, pos.z)

		if minetest.get_node(pos_above).name == "air" then
			minetest.set_node(pos_above, {name = "winterize:ice"})
		end
	end
})

local function snow_can_fall_freely(pos)
	local voxelmanip = VoxelManip()
	local aircheck_pos = vector.new(pos.x, pos.y + 20, pos.z)
	local vpos1, vpos2 = voxelmanip:read_from_map(pos, aircheck_pos)
	local voxelarea = VoxelArea:new{MinEdge=vpos1, MaxEdge=vpos2}
	local nodes_above = voxelmanip:get_data()

	for ypos = pos.y, aircheck_pos.y, 1 do
		local nodeid = nodes_above[voxelarea:indexp(vector.new(pos.x, ypos, pos.z))]
		if nodeid ~= minetest.CONTENT_AIR and
		minetest.registered_items[minetest.get_name_from_content_id(nodeid)].pointable then -- ignore barriers
			return false -- Obstruction found
		end
	end

	return true -- Snow can fall freely
end

minetest.register_lbm({
	label = "Place snow on top of nodes",
	name = "winterize:top_nodes_with_snow",
	nodenames = {"group:crumbly", "group:leaves", "group:cracky", "group:choppy"},
	run_at_every_load = true,
	action = function(pos, node)
		local pos_above = vector.new(pos.x, pos.y + 1, pos.z)

		for _, searchfor in pairs(snow_placement_blacklist) do
			if node.name:find(searchfor) ~= nil then
				return
			end
		end

		if minetest.get_node(pos_above).name == "air" and minetest.registered_items[node.name].walkable then
			if snow_can_fall_freely(pos_above) then
				minetest.set_node(pos_above, {name = "default:snow"})
			end
		end
	end
})

for _, leaftype in pairs(leaves) do
	minetest.override_item("default:" .. leaftype, {
		tiles = {"winterize_dead_leaves.png"},
	})

	minetest.override_item("ctf_map:" .. leaftype, {
		tiles = {"winterize_dead_leaves.png"},
	})
end

for _, grasstype in pairs(grasses) do
	minetest.override_item("default:dirt_with_" .. grasstype, {
		tiles = snowy_dirt_tiles,
		sounds = snowy_dirt_sounds,
	})

	if minetest.registered_nodes["ctf_map:dirt_with_" .. grasstype] then
		minetest.override_item("ctf_map:dirt_with_" .. grasstype, {
			tiles = snowy_dirt_tiles,
			sounds = snowy_dirt_sounds,
		})
	end
end
