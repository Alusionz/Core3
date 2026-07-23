--Copyright (C) 2010 <SWGEmu>
--This File is part of Core3.

object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen3 = object_draft_schematic_weapon_lightsaber_shared_lightsaber_one_hand_gen3:new {

   templateType = DRAFTSCHEMATIC,

   customObjectName = "Third Generation Lightsaber",

   craftingToolTab = 2048,
   complexity = 18,
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

   -- Pre-P9: Gen3 requires materials + force crystal + Gen2 lightsaber
   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "force_crystal", "activator", "handgrip", "power_field_insulator", "energizers", "previous_generation_lightsaber"},
   ingredientSlotType = {0, 1, 0, 0, 0, 0, 1},
   resourceTypes = {"metal_ferrous", "object/tangible/component/weapon/lightsaber/shared_lightsaber_module_force_crystal.iff", "aluminum_titanium", "petrochem_inert_polymer", "gas_inert_culsion", "copper_polysteel", "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_gen2_pre9.iff"},
   resourceQuantities = {35, 1, 20, 25, 25, 25, 1},
   contribution = {100, 200, 100, 100, 100, 100, 100},

   targetTemplate = "object/weapon/melee/sword/crafted_saber/sword_lightsaber_one_handed_gen3.iff",

   additionalTemplates = {
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s1_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s2_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s3_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s4_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s5_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s6_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s7_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s8_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s9_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s10_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s11_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s12_gen3.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s13_gen3.iff",
             }

}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen3, "object/draft_schematic/weapon/lightsaber/lightsaber_one_hand_gen3.iff")
