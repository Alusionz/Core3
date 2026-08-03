spiderclan_elder = Creature:new {
	objectName = "@mob/creature_names:spider_nightsister_elder",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "spider_nightsister",
	faction = "spider_nightsister",
	level = 277,
	chanceHit = 27.25,
	damageMin = 456,
	damageMax = 825,
	baseXp = 26555,
	baseHAM = 140000,
	baseHAMmax = 175000,
	armor = 2,
	resists = {56,55,59,56,55,55,62,55,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER + HEALER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_dathomir_spider_nightsister_elder.iff"},
	lootGroups = {
		{
			groups = {
				{group = "spider_nightsister_tier_5", chance = 10000000}
			}
		}
	},

	primaryWeapon = "force_sword",
	secondaryWeapon = "force_sword_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(pikemanmaster,swordsmanmaster,fencermaster,brawlermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(spiderclan_elder, "spiderclan_elder")
