peko_peko_albatross = Creature:new {
	objectName = "@mob/creature_names:peko_peko_albatross",
	socialGroup = "peko",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 155,
	chanceHit = 5.5,
	-- Pre-P9 high-CL pass: ~70% damage reduction, ~50% HAM, softened resists
	damageMin = 285,
	damageMax = 480,
	baseXp = 14694,
	baseHAM = 37000,
	baseHAMmax = 45500,
	armor = 2,
	resists = {80,80,65,80,80,80,25,25,-1},
	meatType = "meat_avian",
	meatAmount = 400,
	hideType = "hide_wooly",
	hideAmount = 120,
	boneType = "bone_avian",
	boneAmount = 100,
	milk = 0,
	tamingChance = 0,
	ferocity = 8,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + HERD + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/peko_peko_hue.iff"},
	hues = { 16, 17, 18, 19, 20, 21, 22, 23 },
	scale = 2.0,
	lootGroups = {
		{
			groups = {
				{group = "peko_albatross", chance = 10000000}
			},
			lootChance = 4100000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"creatureareacombo",""}, {"creatureareaknockdown",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(peko_peko_albatross, "peko_peko_albatross")
