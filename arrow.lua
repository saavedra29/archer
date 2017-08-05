minetest.register_craftitem("archer:arrow", {
	description = "Arrow",
	inventory_image = "archer_arrow.png",
})

-- The arrow appearance
minetest.register_node("archer:arrow_box", {
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
	tiles = {"archer_arrow.png", "archer_arrow.png", "archer_arrow_back.png", "archer_arrow_front.png", "archer_arrow_2.png", "archer_arrow.png"},
	groups = {not_in_creative_inventory = 1},
})

local ARCHER_ARROW_ENTITY = {
	physical = false,
	timer = 0,
	visual = "wielditem",
	visual_size = {x = 0.125, y = 0.125},
	textures = {"archer:arrow_box"},
	lastpos= {},
	collisionbox = {0, 0, 0, 0, 0, 0},

}

ARCHER_ARROW_ENTITY.on_step = function(self, dtime)
	-- Renew timer
	self.timer = self.timer + dtime
	-- Get arrow's position
	local pos = self.object:getpos()
	-- Get current arrow's position node
	local node = minetest.get_node(pos)

	-- Let 200 milliseconds for the arrow to leave the player
	if self.timer > 0.2 then
		-- Get an array of the objects that exist 1 block around the arrow
		local objs = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 1)
		-- Loop through the objects
		for k, obj in pairs(objs) do
			-- If the object is not player..
			if obj:get_luaentity() ~= nil then
				-- If the object is not arrow && is not something thrown down..
				if obj:get_luaentity().name ~= "archer:arrow_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					local damage = 1
					-- Use the punch method on the object to cause damage
					obj:punch(self.object, 1.0, {
						-- Guess: it means it can't cause damage more often than every 1 second
						full_punch_interval = 1.0,
						-- Guess: It damages only monsters, animals etc. (1 point)
						damage_groups= {fleshy = damage},
					}, nil)
					minetest.sound_play("archer_arrow", {pos = self.lastpos, gain = 0.8})
					self.object:remove()
				end
			else
				-- It is player so cause damage exactly as at the previous lines
				local damage = 1
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
		-- If not in creative mode don't disappear the arrow after the use. Throw it down
		if minetest.registered_nodes[node.name].walkable then
			-- if not minetest.setting_getbool("creative_mode") then
			-- 	minetest.add_item(self.lastpos, "archer:arrow")
			-- end
			minetest.sound_play("archer_arrow", {pos = self.lastpos, gain = 0.8})
			self.object:remove()
		end
	end
	-- Record the last position
	self.lastpos= {x = pos.x, y = pos.y, z = pos.z}
end

minetest.register_entity("archer:arrow_entity", ARCHER_ARROW_ENTITY)

minetest.register_craft({
	output = "archer:arrow 16",
	recipe = {
		{"default:cobble", "group:stick", "group:stick"},
	}
})

minetest.register_craft({
	output = "archer:arrow 16",
	recipe = {
		{"group:stick", "group:stick", "default:cobble"},
	}
})
