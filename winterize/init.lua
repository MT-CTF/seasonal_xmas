local snowy_dirt_tiles = minetest.registered_nodes["default:dirt_with_snow"].tiles
local snowy_dirt_sounds = minetest.registered_nodes["default:dirt_with_snow"].sounds
local grasses = {"dry_grass", "grass", "coniferous_litter",}
local leaves = {"leaves", "aspen_leaves", "jungleleaves"}

minetest.register_node("winterize:ice", { -- breaks instantly, drops nothing
	drawtype = "nodebox",
	description = "Ice",
	tiles = {"default_ice.png"},
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
	groups = {dig_immediate = 3, cools_lava = 1, slippery = 4},
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

minetest.register_lbm({
	label = "Place snow on top of nodes",
	name = "winterize:top_nodes_with_snow",
	nodenames = {"group:crumbly", "group:leaves"},
	run_at_every_load = true,
	action = function(pos, node)
		local pos_above = vector.new(pos.x, pos.y + 1, pos.z)

		if minetest.get_node(pos_above).name == "air" and node.name ~= "default:snow" then
			minetest.set_node(pos_above, {name = "default:snow"})
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
