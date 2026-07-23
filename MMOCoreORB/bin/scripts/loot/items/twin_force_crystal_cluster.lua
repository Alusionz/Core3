-- Twin Force Crystal Cluster (pre-Pub 9 dual-blade enabler)
-- Drops from the same sources as normal crystals

twin_force_crystal_cluster = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Twin Force Crystal Cluster",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"color",31,31,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("twin_force_crystal_cluster", twin_force_crystal_cluster)
