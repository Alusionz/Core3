spiderclan_protector = Creature:new {
	objectName = "@mob/creature_names:spider_nightsister_protector",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "spider_nightsister",
	faction = "spider_nightsister",
	level = 131,
	chanceHit = 4.75,
	damageMin = 231,
	damageMax = 375,
	baseXp = 12424,
	baseHAM = 30000,
	baseHAMmax = 38000,
	armor = 1,
	resists = {45,66,55,45,55,55,38,55,-1},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_dathomir_spider_nightsister_protector.iff"},
	lootGroups = {
		{
			groups = {
				{group = "spider_nightsister_tier_4", chance = 10000000}
			}
		}
	},

	primaryWeapon = "force_sword",
	secondaryWeapon = "force_sword_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(pikemanmaster,swordsmanmaster,fencermaster,brawlermaster,forcewielder),
	secondaryAttacks = forcewielder
}

CreatureTemplates:addCreatureTemplate(spiderclan_protector, "spiderclan_protector")
