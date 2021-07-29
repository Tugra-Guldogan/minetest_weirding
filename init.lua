



local weirding = {
	just_placed = {},
}


local function clear() 
	weirding.just_placed = {}
	minetest.after(1, clear)
end

minetest.after(1, clear)




minetest.register_node("weirding:mover", {
	description = "mover",
	tiles = {
		"default_dirt.png^weirding_yellow_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:mover"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		local right_dir = vector.cross(top_dir, back_dir)
		
-- 		local front_dir = vector.multiply(back_dir, -1)
		local backpos = vector.add(pos, top_dir)
		local frontpos = vector.add(backpos, back_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
		
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name ~= "air" then
			return
		end
		
		local fhash = minetest.hash_node_position(frontpos)
		weirding.just_placed[fhash] = true
		
		
		minetest.swap_node(frontpos, bnode)
		minetest.set_node(backpos, {name="air"})
		
		minetest.check_for_falling(frontpos)
	end,
})


minetest.register_node("weirding:dropper", {
	description = "mover",
	tiles = {
		"default_dirt.png^weirding_yellow_arrow_circle.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:dropper"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		
		local front_dir = vector.multiply(back_dir, -1)
		local toppos = vector.add(pos, top_dir)
		local backpos = vector.add(pos, back_dir)
		local frontpos = vector.add(pos, back_dir)
		
		local tnode = minetest.get_node(toppos)
		if tnode == nil or tnode.name == "air" then
			return
		end
		
		local thash = minetest.hash_node_position(toppos)
		if weirding.just_placed[thash] == true then
			return
		end
		
		-- try the front
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name == "air" then
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, tnode)
			minetest.set_node(toppos, {name="air"})
			
			minetest.check_for_falling(frontpos)
			return
		end
		
		-- try moving on
		local frontpos = vector.add(toppos, back_dir)
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name == "air" then
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, tnode)
			minetest.set_node(toppos, {name="air"})
			
			minetest.check_for_falling(frontpos)
			return
		end
	end,
})


--[[
minetest.register_node("weirding:rotator", {
	description = "rotator",
	tiles = {
		"default_dirt.png^weirding_green_circle_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})
minetest.register_abm({
	nodenames = {"weirding:rotator"},
-- 	neighbors = {"group:soil"},
	interval = 10000000,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		local right_dir = vector.cross(top_dir, back_dir)
		
-- 		local front_dir = vector.multiply(back_dir, -1)
		local backpos = vector.add(pos, back_dir)
		
		local i = 0
		while true do
			
			local frontpos = vector.add(pos, right_dir)
			
			
			local bnode = minetest.get_node(backpos)
			if bnode == nil or bnode.name == "air" then
				return
			end
			
			local bhash = minetest.hash_node_position(backpos)
			if weirding.just_placed[bhash] == true then
				return
			end
			
			
			local fnode = minetest.get_node(frontpos)
			if fnode ~= nil and fnode.name ~= "air" then
				return
			end
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, bnode)
			minetest.set_node(backpos, {name="air"})
			
			break
		end
	end,
})
]]

minetest.register_abm({
	nodenames = {"weirding:rotator"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		local backpos = vector.add(pos, back_dir) 
		
		
		
		local front_dir = vector.cross(back_dir, -1)
		local frontpos = vector.add(pos, front_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
		
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name ~= "air" then
			return
		end
		
		local fhash = minetest.hash_node_position(frontpos)
		weirding.just_placed[fhash] = true
		
		minetest.swap_node(frontpos, bnode)
		minetest.set_node(backpos, {name="air"})
		
	end,
})





minetest.register_node("weirding:eater", {
	description = "eater",
	tiles = {
		"default_dirt.png^weirding_red_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:eater"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local front_dir = minetest.facedir_to_dir(node.param2)
		local frontpos = vector.add(pos, front_dir)
		
		local back_dir = vector.multiply(front_dir, -1)
		local backpos = vector.add(pos, back_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
	
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local meta = minetest.get_meta(frontpos)
		if meta == nil then return end
		local inv = meta:get_inventory()
		if inv == nil then return end
		if inv:get_size("main") == 0 then return end
		
		local drops = minetest.get_node_drops(bnode.name, nil)
		for _,v in ipairs(drops) do
			inv:add_item("main", v)
		end
		
		minetest.set_node(backpos, {name="air"})
		
	end,
})


minetest.register_node("weirding:green_node", {
	description = "green node",
	tiles = {
		"default_dirt.png^[colorize:green:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
})

minetest.register_node("weirding:purple_node", {
	description = "purple node",
	tiles = {
		"default_dirt.png^[colorize:purple:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
})
minetest.register_node("weirding:orange_node", {
	description = "orange node",
	tiles = {
		"default_dirt.png^[colorize:orange:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
})



minetest.register_node("weirding:red_node", {
	description = "red node",
	tiles = {
		"default_dirt.png^[colorize:red:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
})

minetest.register_node("weirding:yellow_node", {
	description = "yellow node",
	tiles = {
		"default_dirt.png^[colorize:yellow:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
})

minetest.register_node("weirding:gray_node", {
	description = "gray node",
	tiles = {
		"default_dirt.png^[colorize:gray:120",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
-- 	paramtype2 = "facedir",
-- 	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_glass_footstep", gain = 0.25},
	}),
	
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local n = meta:get_string("name")
		if n ~= "" then
			minetest.set_node(pos, {
				name = n,
				param2 = meta:get_int("param2"),
			})
		end
	end,
})



local function set_later(pos, name)
	local n = name
	local p = {x=pos.x, y=pos.y, z=pos.z}
	minetest.after(1, function()
		minetest.set_node(p, {name=n})
	end)
end
local function set_now(pos, name)
	minetest.set_node(pos, {name=name})
end



minetest.register_abm({
	nodenames = {"weirding:red_node"},
	neighbors = {"weirding:red_node"},
	interval = 2,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		if node.name ~= "weirding:red_node" then return end
		
-- 		local bhash = minetest.hash_node_position(pos)
-- 		if weirding.just_placed[bhash] == true then
-- 			return
-- 		end
-- 		weirding.just_placed[bhash] = true
		
		local red_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			{"weirding:red_node"}
		)
		
--  		if #red_nodes >= 4 then 
-- 			minetest.set_node(pos, {name="weirding:green_node"})
-- 			return
--  		end
		
		for _,rnp in ipairs(red_nodes) do
			
-- 			local bhash = minetest.hash_node_position(rnp)
-- 			if weirding.just_placed[bhash] == true then
-- 				return
-- 			end
-- 			weirding.just_placed[bhash] = true
			
			local d = vector.subtract(pos, rnp);
			local opp = vector.add(pos, d);
			
			local on = minetest.get_node(opp)
			if on ~= nil and (on.name == "air" or minetest.registered_nodes[on.name].buildable_to) then
-- 				minetest.set_node(rnp, {name="air"})
					set_later(opp, "weirding:red_node")
			end
		end
-- 		
-- 		minetest.set_node(pos, {name="weirding:red_node"})
		
	end,
})


minetest.register_abm({
	nodenames = {"weirding:yellow_node"},
	neighbors = {"weirding:red_node"},
	interval = 2,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		if node.name ~= "weirding:yellow_node" then return end
		
		local red_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			{"weirding:red_node"}
		)
		
		for _,rnp in ipairs(red_nodes) do
			
			local bhash = minetest.hash_node_position(rnp)
			if weirding.just_placed[bhash] == true then
				return
			end
			weirding.just_placed[bhash] = true
			
			local d = vector.subtract(pos, rnp);
			local opp = vector.add(pos, d);
			
			local on = minetest.get_node(opp)
			if on ~= nil and on.name ~= "air" then
-- 				minetest.set_node(rnp, {name="air"})
				minetest.set_node(rnp, {name="weirding:gray_node"})
				local meta = minetest.get_meta(rnp)
				meta:set_string("name", on.name)
				meta:set_int("param2", on.param2)
				
				local t = minetest.get_node_timer(rnp)
				t:start(10)
			end
		end
		
	end,
})

minetest.register_abm({
	nodenames = {"weirding:gray_node"},
	neighbors = {"weirding:red_node"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node = minetest.get_node(pos)
		if node.name ~= "weirding:gray_node" then return end
		
		local nmeta = minetest.get_meta(pos)
		local param2 = nmeta:get_int("param2")
		local name = nmeta:get_string("name")
		
		local red_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			{"weirding:red_node"}
		)
		
		for _,rnp in ipairs(red_nodes) do
			
-- 				minetest.set_node(rnp, {name="air"})
				minetest.set_node(rnp, {name="weirding:gray_node"})
				local meta = minetest.get_meta(rnp)
				meta:set_string("name", name)
				meta:set_int("param2", param2)
				
				local t = minetest.get_node_timer(rnp)
				t:start(10)
		end
		
	end,
})

-- clear
minetest.register_abm({
	nodenames = {"weirding:green_node", "weirding:red_node"},
	interval = 100000000,
	chance = 1,
--	catch_up = true,
	action = function(pos)
-- 		minetest.set_node(pos, {name="air"})
	end,
})

minetest.register_abm({
	nodenames = {"weirding:green_node"},
	neighbors = {"weirding:purple_node"},
	interval = 2,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		if node.name ~= "weirding:green_node" then 
-- 			minetest.set_node(pos, {name="air"})
			return
		end
		
		local bhash = minetest.hash_node_position(pos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		
		local purple_nodes = minetest.find_nodes_in_area(
			{x=pos.x - 1, y=pos.y - 1, z=pos.z - 1},
			{x=pos.x + 1, y=pos.y + 1, z=pos.z + 1},
			{"weirding:purple_node"}
		)
		
		if #purple_nodes ~= 1 then 
			minetest.set_node(pos, {name="default:glass"})
			return
		end
		
		local pu_pos = purple_nodes[1]
		
		local orange_nodes = minetest.find_nodes_in_area(
			{x=pu_pos.x - 1, y=pu_pos.y - 1, z=pu_pos.z - 1},
			{x=pu_pos.x + 1, y=pu_pos.y + 1, z=pu_pos.z + 1},
			{"weirding:orange_node"}
		)
		if #orange_nodes ~= 1 then 
			minetest.set_node(pos, {name="default:glass"})
			return
		end
		
		local or_pos = orange_nodes[1]
		local mvdir = vector.subtract(pos, pu_pos)

		local or_next_pos = vector.add(or_pos, mvdir)
		local orn = minetest.get_node(or_next_pos)
		if orn and not minetest.registered_nodes[orn.name].buildable_to then
			minetest.set_node(pos, {name="default:glass"})
			return
		end
		
		
		
		local dir = vector.subtract(pu_pos, or_pos)
-- 		local inv_dir = vector.multiply(dir, -1)
		
		-- from the corner to behind
		local source_pos_a = vector.add(pos, mvdir)
		local target_pos_a = vector.add(source_pos_a, dir)
		
		local src_a = minetest.get_node(source_pos_a)
		local tar_a = minetest.get_node(target_pos_a)
		minetest.swap_node(source_pos_a, tar_a)
		minetest.swap_node(target_pos_a, src_a)
	
		
		local mvdir = vector.subtract(pos, pu_pos)
		minetest.set_node(pu_pos, {name="air"})
		minetest.set_node(or_pos, {name="air"})
		minetest.set_node(pos, {name="air"})
		set_now(vector.add(pu_pos, mvdir), "weirding:purple_node")
		set_now(vector.add(or_pos, mvdir), "weirding:orange_node")
		set_now(vector.add(pos, mvdir), "weirding:green_node")
		
		weirding.just_placed[minetest.hash_node_position(vector.add(pos, mvdir))] = true
		
		
	end,
})
