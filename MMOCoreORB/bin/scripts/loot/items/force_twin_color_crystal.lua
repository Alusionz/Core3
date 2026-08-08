-- Pre-P9: Twin Force Crystal Cluster
-- Rare dual-blade (polearm) crafting component. Same color + power stats as color crystals.
-- Uses lance module template so 1h/2h schematics cannot accept it.

force_twin_color_crystal = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Twin Force Crystal Cluster",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_lance_module_force_crystal.iff",
	craftingValues = {
		{"color",0,11,0},  -- random blade color for client appearance
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_twin_color_crystal", force_twin_color_crystal)
