--Copyright (C) 2010 <SWGEmu>
--This File is part of Core3.

object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen5 = object_draft_schematic_weapon_lightsaber_shared_lightsaber_polearm_gen5:new {

   templateType = DRAFTSCHEMATIC,

   customObjectName = "Double-Bladed Fifth Generation Lightsaber",

   craftingToolTab = 2048,
   complexity = 20,
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

   -- Pre-P9 dual-blade Gen5: materials + force crystal (Twin) + Gen4 dual-blade lightsaber
   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "force_crystal", "activator", "handgrip", "power_field_insulator", "energizers", "previous_generation_lightsaber"},
   ingredientSlotType = {0, 1, 0, 0, 0, 0, 1},
   resourceTypes = {"steel_duralloy", "object/tangible/component/weapon/lightsaber/shared_lightsaber_module_force_crystal.iff", "aluminum_titanium", "petrochem_inert_polymer", "gas_inert_culsion", "copper_polysteel", "object/weapon/melee/polearm/crafted_saber/shared_sword_lightsaber_polearm_gen4.iff"},
   resourceQuantities = {45, 1, 32, 48, 60, 60, 1},
   contribution = {100, 200, 100, 100, 100, 100, 100},

   targetTemplate = "object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen5.iff",

   additionalTemplates = {
             }

}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_polearm_gen5, "object/draft_schematic/weapon/lightsaber/lightsaber_polearm_gen5.iff")
