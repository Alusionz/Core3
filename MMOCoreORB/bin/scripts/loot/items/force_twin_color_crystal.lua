force_twin_color_crystal = {
  minimumLevel = 0,
  maximumLevel = -1,
  customObjectName = "Twin Force-Crystal Cluster",
  directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_color.iff",
  craftingValues = {
    {"color",0,11,0},  -- random color
    {50, 1, 1, 0},  -- custom marker byte key 50 = 1
  },
}
addLootItemTemplate("force_twin_color_crystal", force_twin_color_crystal)