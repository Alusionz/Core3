force_twin_color_crystal = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Twin Force Crystal Cluster",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"color",0,11,0},  -- Pre-P9: random color for client appearance (same as color crystals)
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_twin_color_crystal", force_twin_color_crystal)
