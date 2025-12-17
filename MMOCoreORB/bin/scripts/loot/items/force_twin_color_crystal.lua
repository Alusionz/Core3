force_twin_color_crystal = {
  minimumLevel = 0,
  maximumLevel = -1,
  customObjectName = "Twin Force-Crystal Cluster",
  directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_color.iff",
  craftingValues = {
    {"color",0,11,0},  -- random color
    {"merged_power_stats", 1, 1, 0},  -- custom marker (1 = apply power stats in C++)
  },
}
addLootItemTemplate("force_twin_color_crystal", force_twin_color_crystal)