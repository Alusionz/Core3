--Copyright (C) 2010 <SWGEmu>
--This File is part of Core3.

object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen4 = object_draft_schematic_weapon_lightsaber_shared_lightsaber_polearm_gen4:new {

   templateType = DRAFTSCHEMATIC,

   customObjectName = "Double-Bladed Fourth Generation Lightsaber",

   craftingToolTab = 2048,
   complexity = 19,
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

   -- Pre-P9 dual-blade Gen4: materials + Twin force crystal + Gen3 dual-blade saber
   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "force_crystal", "activator", "handgrip", "power_field_insulator", "energizers", "previous_generation_lightsaber"},
   ingredientSlotType = {0, 1, 0, 0, 0, 0, 1},
   resourceTypes = {"steel_duralloy", "object/tangible/component/weapon/lightsaber/shared_lightsaber_lance_module_force_crystal.iff", "aluminum_titanium", "petrochem_inert_polymer", "gas_inert_culsion", "copper_polysteel", "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_gen3.iff"},
   resourceQuantities = {40, 1, 32, 32, 48, 48, 1},
   contribution = {100, 200, 100, 100, 100, 100, 100},

   targetTemplate = "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen4.iff",

   additionalTemplates = {
              "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_s1_gen4.iff",
              "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_s2_gen4.iff",
             }

}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen4, "object/draft_schematic/weapon/lightsaber/lightsaber_polearm_gen4.iff")
