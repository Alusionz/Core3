-- Pre-P9 cleanup: power_crystals group no longer drops pure power crystals.
-- Redirects to the same color + twin pool so any leftover mobile references are safe.

power_crystals = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "force_color_crystal", weight = 9200000},
		{itemTemplate = "force_twin_color_crystal", weight = 800000}
	}
}

addLootGroupTemplate("power_crystals", power_crystals)
