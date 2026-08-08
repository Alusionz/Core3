-- Pre-P9: higher twin chance for high-end humanoid force users
-- Used by nightsister_tier_4/5, spider high tiers, force_tier_4, dark_jedi high tiers, etc.

color_crystals_highend = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "force_color_crystal", weight = 7500000},
		{itemTemplate = "force_twin_color_crystal", weight = 2500000}  -- 25% twin on high-end humanoids
	}
}

addLootGroupTemplate("color_crystals_highend", color_crystals_highend)
