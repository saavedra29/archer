-- Configuring variables
GRAVITY = 10
VELOCITY = 19

-- Velocity
WOODEN_BOW_VELOCITY = 15
STONE_BOW_VELOCITY = 19
STEEL_BOW_VELOCITY = 23
BRONZE_BOW_VELOCITY = 25
MESE_BOW_VELOCITY = 29
DIAMOND_BOW_VELOCITY = 33

-- Durability
WOODEN_BOW_DURABILITY = 30
STONE_BOW_DURABILITY = 60
STEEL_BOW_DURABILITY = 90
BRONZE_BOW_DURABILITY = 100
MESE_BOW_DURABILITY = 150
DIAMOND_BOW_DURABILITY = 200

SHOOTING_DELAY = 1.2

local playersStates = {}


-- The first element is registered CRAFTITEM and the second registered ENTITY
arrows = {
	{"archer:arrow", "archer:arrow_entity"},
	{"archer:arrow_gold", "archer:arrow_gold_entity"},
	{"archer:arrow_steel", "archer:arrow_steel_entity"}
}

local archer_shoot_arrow = function(itemstack, player)
	for _,arrow in ipairs(arrows) do
		-- If the player HAS an arrow in the inventory to the right of the bow..
		if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
			-- If we are not at the creative_mode..
			if not minetest.setting_getbool("creative_mode") then
				-- Remove the item from the inventory
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:getpos()
			-- Create a new entity at the position 1.5 nodes above the player
			local obj = minetest.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
			-- Get the player's direction
			local dir = player:get_look_dir()
			-- The endVelocity (actual velocity) raises exponentially according to the bow's
			-- material and the player's hitpoints
			local endVelocity = VELOCITY*(1-4^(-player:get_hp()/7))
			-- Set velocity, acceleration and orientation of the arrow
			obj:setvelocity({x=dir.x*endVelocity, y=dir.y*endVelocity, z=dir.z*endVelocity})
			obj:setacceleration({x=dir.x*-3, y=-GRAVITY, z=dir.z*-3})
			obj:setyaw(player:get_look_horizontal()+math.pi)
			-- Play sound
			minetest.sound_play("archer_sound", {pos=playerpos, gain = 0.5})
			-- Probably: If the arrow is taken from the ground..
			if obj:get_luaentity().player == "" then
				-- Make it belong to the player
				obj:get_luaentity().player = player
			end
			-- Gives name to the object (i.e. "archer:arrow")
			obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
			return true
		end
	end
	return false
end

-- Checks if the time delay has passed between shots
local readyToShoot = function(player)
	local name = player:get_player_name()
	if playersStates[name] == nil or playersStates[name] == true then
		playersStates[name] = false
		minetest.after(SHOOTING_DELAY, function(name)
			playersStates[name] = true
		end, name)
		return true
	else
		return false
	end
end



-- Register the item
minetest.register_tool("archer:bow_wood", {
	description = "Wooden Bow",
	inventory_image = "archer_bow_wood.png",
	-- The function to be called when the arrow is used
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = WOODEN_BOW_VELOCITY
		-- Check if 2 seconds have passed since last shot
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				-- If we are not in creative mode add wear to the bow
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/WOODEN_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})


-- Registering the bows
-- The more expensive modes have longer lifetime

minetest.register_craft({
	output = "archer:bow_wood",
	recipe = {
		{"farming:cotton", "group:wood", ""},
		{"farming:cotton", "", "group:wood"},
		{"farming:cotton", "group:wood", ""},
	}
})



minetest.register_tool("archer:bow_stone", {
	description = "Stone Bow",
	inventory_image = "archer_bow_stone.png",
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = STONE_BOW_VELOCITY
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/STONE_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "archer:bow_stone",
	recipe = {
		{"farming:cotton", "default:cobble", ""},
		{"farming:cotton", "", "default:cobble"},
		{"farming:cotton", "default:cobble", ""},
	}
})



minetest.register_tool("archer:bow_steel", {
	description = "Steel Bow",
	inventory_image = "archer_bow_steel.png",
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = STEEL_BOW_VELOCITY
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/STEEL_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "archer:bow_steel",
	recipe = {
		{"farming:cotton", "default:steel_ingot", ""},
		{"farming:cotton", "", "default:steel_ingot"},
		{"farming:cotton", "default:steel_ingot", ""},
	}
})



minetest.register_tool("archer:bow_bronze", {
	description = "Bronze Bow",
	inventory_image = "archer_bow_bronze.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = BRONZE_BOW_VELOCITY
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/BRONZE_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "archer:bow_bronze",
	recipe = {
		{"farming:cotton", "default:bronze_ingot", ""},
		{"farming:cotton", "", "default:bronze_ingot"},
		{"farming:cotton", "default:bronze_ingot", ""},
	}
})



minetest.register_tool("archer:bow_mese", {
	description = "Mese Bow",
	inventory_image = "archer_bow_mese.png",
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = MESE_BOW_VELOCITY
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/MESE_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "archer:bow_mese",
	recipe = {
		{"farming:cotton", "default:mese_crystal", ""},
		{"farming:cotton", "", "default:mese_crystal"},
		{"farming:cotton", "default:mese_crystal", ""},
	}
})



minetest.register_tool("archer:bow_diamond", {
	description = "Diamond Bow",
	inventory_image = "archer_bow_diamond.png",
	on_use = function(itemstack, user, pointed_thing)
		VELOCITY = DIAMOND_BOW_VELOCITY
		if readyToShoot(user) then
			if archer_shoot_arrow(itemstack, user, pointed_thing) then
				if not minetest.setting_getbool("creative_mode") then
					itemstack:add_wear(65535/DIAMOND_BOW_DURABILITY)
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "archer:bow_diamond",
	recipe = {
		{"farming:cotton", "default:diamond", ""},
		{"farming:cotton", "", "default:diamond"},
		{"farming:cotton", "default:diamond", ""},
	}
})

dofile(minetest.get_modpath("archer") .. "/arrow.lua")
dofile(minetest.get_modpath("archer") .. "/golden_arrow.lua")
dofile(minetest.get_modpath("archer") .. "/steel_arrow.lua")

-- if minetest.setting_getbool("log_mods") then
-- 	minetest.log("action", "Carbone: [archer] loaded.")
-- end
