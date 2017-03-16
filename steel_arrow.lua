minetest.register_craftitem("archer:arrow_steel", {
	description = "Steel Arrow",
	inventory_image = "archer_arrow_steel.png",
})

minetest.register_node("archer:arrow_steel_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Shaft
			{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
			-- Spitze
			{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
			{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
			-- Federn
			{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
			{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
			{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
			{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},

			{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
			{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
			{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
			{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
		}
	},
	tiles = {"archer_arrow_steel.png", "archer_arrow_steel.png", "archer_arrow_steel_back.png", "archer_arrow_steel_front.png", "archer_arrow_steel_2.png", "archer_arrow_steel.png"},
	groups = {not_in_creative_inventory = 1},
})

local ARCHER_arrow_steel_ENTITY = {
	physical = false,
	timer = 0,
	visual = "wielditem",
	visual_size = {x = 0.125, y = 0.125},
	textures = {"archer:arrow_steel_box"},
	lastpos= {},
	collisionbox = {0, 0, 0, 0, 0, 0},
}

ARCHER_arrow_steel_ENTITY.on_step = function(self, dtime)
	self.timer = self.timer + dtime
	local pos = self.object:getpos()
	local node = minetest.get_node(pos)

	if self.timer > 0.2 then
		local objs = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 1)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "archer:arrow_steel_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					local damage = 3
					obj:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups= {fleshy = damage},
					}, nil)
					minetest.sound_play("archer_arrow", {pos = self.lastpos, gain = 0.8})
					self.object:remove()
				end
			else
				local damage = 3
				obj:punch(self.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups= {fleshy = damage},
				}, nil)
				minetest.sound_play("archer_arrow", {pos = self.lastpos, gain = 0.8})
				self.object:remove()
			end
		end
	end

	if self.lastpos.x ~= nil then
		if minetest.registered_nodes[node.name].walkable then
			-- if not minetest.setting_getbool("creative_mode") then
			-- 	minetest.add_item(self.lastpos, "archer:arrow_steel")
			-- end
			minetest.sound_play("archer_arrow", {pos = self.lastpos, gain = 0.8})
			self.object:remove()
		end
	end
	self.lastpos= {x = pos.x, y = pos.y, z = pos.z}
end

minetest.register_entity("archer:arrow_steel_entity", ARCHER_arrow_steel_ENTITY)

minetest.register_craft({
	output = "archer:arrow_steel 16",
	recipe = {
		{"group:stick", "group:stick", "default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "archer:arrow_steel 16",
	recipe = {
		{"default:steel_ingot", "group:stick", "group:stick"},
	}
})
