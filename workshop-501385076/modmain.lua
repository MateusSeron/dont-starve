function pick(inst)
	if inst.components.pickable then
	inst.components.pickable.quickpick = true
	end
end

AddPrefabPostInit("sapling", pick)
AddPrefabPostInit("marsh_bush", pick)
AddPrefabPostInit("reeds", pick)
AddPrefabPostInit("grass", pick)
AddPrefabPostInit("berrybush2", pick)
AddPrefabPostInit("berrybush", pick)
AddPrefabPostInit("flower_cave", pick)
AddPrefabPostInit("flower_cave_double", pick)
AddPrefabPostInit("flower_cave_triple", pick)
AddPrefabPostInit("red_mushroom", pick)
AddPrefabPostInit("green_mushroom", pick)
AddPrefabPostInit("blue_mushroom", pick)
AddPrefabPostInit("cactus", pick)
AddPrefabPostInit("lichen", pick)