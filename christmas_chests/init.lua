if os.date("%m") ~= "12" then return end

minetest.override_item("ctf_map:chest", {
	tiles = {"christmas_chests_top.png", "christmas_chests_bottom.png", "christmas_chests_side.png",
		"christmas_chests_side.png", "christmas_chests_side.png", "christmas_chests_front.png"}
})