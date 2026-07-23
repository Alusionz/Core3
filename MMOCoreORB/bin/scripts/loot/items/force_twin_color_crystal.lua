force_twin_color_crystal = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Twin Force Crystal Cluster",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"color",31,31,0},  -- tuned crystal (color 31) for pre-P9 dual-blade lightsaber crafting
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("force_twin_color_crystal", force_twin_color_crystal)
