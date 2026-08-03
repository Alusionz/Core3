singing_mountain_clan_councilwoman = Creature:new {
	objectName = "@mob/creature_names:singing_mtn_clan_councilwoman",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "mtn_clan",
	faction = "mtn_clan",
	level = 253,
	chanceHit = 23.5,
	damageMin = 419,
	damageMax = 750,
	baseXp = 24180,
	baseHAM = 115000,
	baseHAMmax = 145000,
	armor = 2,
	resists = {55,35,35,55,55,55,55,55,-1},
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

	templates = {"object/mobile/dressed_dathomir_sing_mt_clan_councilwoman.iff"},
	lootGroups = {
		{
			groups = {
				{group = "mtn_clan_tier_5", chance = 10000000}
			}
		}
	},

	primaryWeapon = "force_sword",
	secondaryWeapon = "force_sword_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(pikemanmaster,swordsmanmaster,fencermaster,brawlermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(singing_mountain_clan_councilwoman, "singing_mountain_clan_councilwoman")
