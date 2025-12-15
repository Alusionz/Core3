-- Pre-P9 Poor Quality Force Crystal
force_crystal_poor = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Poor Quality Force Crystal",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"mindamage",5,15,0},
		{"maxdamage",15,25,0},
		{"attackspeed",-1.2,0.8,0},
		{"force_cost",15,35,0},
		{"color",0,11,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}
addLootItemTemplate("force_crystal_poor", force_crystal_poor)