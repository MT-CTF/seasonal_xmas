local snowy_dirt_tiles = minetest.registered_nodes["default:dirt_with_snow"].tiles
local snowy_dirt_sounds = minetest.registered_nodes["default:dirt_with_snow"].sounds
local grasses = {"dry_grass", "grass", "rainforest_litter", "grass"}

for _, grasstype in pairs(grasses) do
	minetest.override_item("default:dirt_with_" .. grasstype, {
		tiles = snowy_dirt_tiles,
		sounds = snowy_dirt_sounds,
	})

	minetest.override_item("ctf_map:dirt_with_" .. grasstype, {
		tiles = snowy_dirt_tiles,
		sounds = snowy_dirt_sounds,
	})
end
