force_crystal_select = { minimumLevel = 0, maximumLevel = -1, customObjectName = "Select Force Crystal", directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"mindamage",80,120,0},
		{"maxdamage",130,190,0},
		{"attackspeed",-0.7,-0.1,0},
		{"force_cost",-10,15,0},
		{"color",0,11,0},
	}
} addLootItemTemplate("force_crystal_select", force_crystal_select)