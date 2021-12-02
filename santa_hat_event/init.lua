if os.date("%m") ~= "12" or not minetest.get_modpath("server_cosmetics") then return end

local META_KEY = "server_cosmetics:snowballs:"..os.date("%Y")
local COSMETIC_KEY = "server_cosmetics:entity:santa_hat:"..os.date("%Y")
local REQUIRED_HITS = 500

local old_func = throwable_snow.on_hit_player
function throwable_snow.on_hit_player(thrower, player, ...)
	local throwerobj = minetest.get_player_by_name(thrower)

	if throwerobj and ctf_teams.get(thrower) ~= ctf_teams.get(player) then
		local meta = throwerobj:get_meta()
		local old_val = meta:get_int(META_KEY)
		local new_val = old_val + 2

		if old_val <= REQUIRED_HITS then
			meta:set_int(META_KEY, new_val)
		end

		if old_val < REQUIRED_HITS and new_val >= REQUIRED_HITS then
			hud_events.new(thrower, {
				text = "You have unlocked this year's christmas hat!",
				color = "success",
			})

			meta:set_int(COSMETIC_KEY, 1)
		end
	end

	old_func(thrower, player, ...)
end

sfinv.register_page("santa_hat_event:progress", {
	title = "Event!",
	is_in_nav = function(self, player)
		return ctf_teams.get(player) and true or false
	end,
	get = function(self, player, context)
		local meta = player:get_meta()
		local players_hit = meta:get_int(META_KEY)

		local form = "real_coordinates[true]"

		if players_hit < REQUIRED_HITS then
			form = string.format("%slabel[0.1,0.5;Hit %d enemy players with a snowball to get a cool christmas hat!\n%s]", form,
				REQUIRED_HITS,
				"Dead enemies count >:)"
			)
		else
			form = form .. "label[0.1,0.5;Nice job! Pop over to the customization tab to try out your new hat!]"
			meta:set_int(COSMETIC_KEY, 1)
		end

		form = form .. string.format([[
			label[0.1,2.7;You've hit %d/%d players with a snowball]
			image[0.1,3;8,1;santa_hat_event_progress_bar.png]] ..
			[[^(([combine:38x8:1,0=santa_hat_event_progress_bar_full.png)^[resize:%dx8)]"
		]],
		players_hit, REQUIRED_HITS,
		math.min((38/REQUIRED_HITS)*players_hit, 38) + 1
		)

		return sfinv.make_formspec(player, context, form, true)
	end,
	on_player_receive_fields = function(self, player, context, fields)
		sfinv.set_page(player, sfinv.get_page(player))
	end,
})
