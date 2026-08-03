juvenile_canyon_krayt_dragon = Creature:new {
	objectName = "@mob/creature_names:juvenile_canyon_krayt",
	socialGroup = "krayt",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 122,
	chanceHit = 4.0,
	damageMin = 224,
	damageMax = 360,
	baseXp = 11577,
	baseHAM = 40000,
	baseHAMmax = 50000,
	armor = 2,
	resists = {85,85,15,15,60,15,15,15,-1},
	meatType = "meat_carnivore",
	meatAmount = 750,
	hideType = "hide_bristley",
	hideAmount = 500,
	boneType = "bone_mammal",
	boneAmount = 410,
	milk = 0,
	tamingChance = 0,
	ferocity = 20,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 0.5,

	templates = {"object/mobile/juvenile_canyon_krayt.iff"},
	hues = { 24, 25, 26, 27, 28, 29, 30, 31 },

	lootGroups = {
		{
			groups = {
				{group = "krayt_dragon_common", chance = 3000000},
				{group = "krayt_pearls", chance = 1500000},
				{group = "krayt_tissue_uncommon", chance = 2000000},
				{group = "armor_all", chance = 1750000},
				{group = "weapons_all", chance = 1750000},
			},
			lootChance = 5500000
		}
	},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"posturedownattack",""}, {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(juvenile_canyon_krayt_dragon, "juvenile_canyon_krayt_dragon")
