singing_mountain_clan_guardian = Creature:new {
	objectName = "@mob/creature_names:singing_mtn_clan_guardian",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "mtn_clan",
	faction = "mtn_clan",
	level = 156,
	chanceHit = 8.5,
	damageMin = 269,
	damageMax = 450,
	baseXp = 14789,
	baseHAM = 45000,
	baseHAMmax = 55000,
	armor = 1,
	resists = {100,30,30,100,100,100,100,100,-1},
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

	templates = {"object/mobile/dressed_dathomir_sing_mt_clan_guardian.iff"},
	lootGroups = {
		{
			groups = {
				{group = "mtn_clan_tier_4", chance = 10000000}
			}
		}
	},

	primaryWeapon = "force_sword",
	secondaryWeapon = "force_sword_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(pikemanmaster,swordsmanmaster,fencermaster,brawlermaster,forcewielder),
	secondaryAttacks = forcewielder
}

CreatureTemplates:addCreatureTemplate(singing_mountain_clan_guardian, "singing_mountain_clan_guardian")
