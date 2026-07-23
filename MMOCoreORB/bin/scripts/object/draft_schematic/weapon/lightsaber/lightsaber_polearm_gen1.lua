--Copyright (C) 2010 <SWGEmu>
--This File is part of Core3.

object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen1 = object_draft_schematic_weapon_lightsaber_shared_lightsaber_polearm_gen1:new {

   templateType = DRAFTSCHEMATIC,

   customObjectName = "Double-Bladed First Generation Lightsaber",

   craftingToolTab = 2048,
   complexity = 16,
   size = 1,
   factoryCrateType = "object/factory/factory_crate_weapon.iff",

   xpType = "jedi_general",
   xp = 0,

   assemblySkill = "jedi_saber_assembly",
   experimentingSkill = "jedi_saber_experimentation",
   customizationSkill = "jedi_customization",
   factoryCrateSize = 0,

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   -- Pre-P9 dual-blade: materials + force crystal (use Twin Force Crystal Cluster / color 31)
   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "force_crystal", "activator", "handgrip", "power_field_insulator", "energizers"},
   ingredientSlotType = {0, 1, 0, 0, 0, 0},
   resourceTypes = {"mineral", "object/tangible/component/weapon/lightsaber/shared_lightsaber_module_force_crystal.iff", "metal", "chemical", "gas", "metal"},
   resourceQuantities = {25, 1, 24, 40, 40, 40},
   contribution = {100, 200, 100, 100, 100, 100},

   targetTemplate = "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen1.iff",

   additionalTemplates = {
              "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_s1_gen1.iff",
              "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_s2_gen1.iff",
             }

}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen1, "object/draft_schematic/weapon/lightsaber/lightsaber_polearm_gen1.iff")
