--Copyright (C) 2010 <SWGEmu>
--This File is part of Core3.

object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen2 = object_draft_schematic_weapon_lightsaber_shared_lightsaber_one_hand_gen2:new {

   templateType = DRAFTSCHEMATIC,

   customObjectName = "Second Generation Lightsaber",
   noCrystalContainer = true,

   craftingToolTab = 2048,
   complexity = 17,
   size = 1,
   factoryCrateType = "object/factory/factory_crate_weapon.iff",

   xpType = "jedi_general",
   xp = 0,

   assemblySkill = "jedi_saber_assembly",
   experimentingSkill = "jedi_saber_experimentation",
   customizationSkill = "jedi_customization",
   factoryCrateSize = 0,

   customizationOptions = {1},
   customizationStringNames = {"/private/index_no_container"},
   customizationDefaults = {1},

   -- Pre-P9: Gen2 requires materials + force crystal + Gen1 lightsaber
   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "force_crystal", "activator", "handgrip", "power_field_insulator", "energizers", "previous_generation_lightsaber"},
   ingredientSlotType = {0, 1, 0, 0, 0, 0, 1},
   resourceTypes = {"metal", "object/tangible/component/weapon/lightsaber/shared_lightsaber_module_force_crystal.iff", "metal_nonferrous", "petrochem_inert", "gas_inert_known", "metal_nonferrous", "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_gen1.iff"},
   resourceQuantities = {25, 1, 18, 20, 22, 20, 1},
   contribution = {100, 200, 100, 100, 100, 100, 100},

   targetTemplate = "object/weapon/melee/sword/crafted_saber/sword_lightsaber_one_handed_gen2_pre9.iff",

   additionalTemplates = {
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s1_gen_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s2_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s3_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s4_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s5_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s6_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s7_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s8_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s9_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s10_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s11_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s12_gen2_pre9.iff",
              "object/weapon/melee/sword/crafted_saber/shared_sword_lightsaber_one_handed_s13_gen2_pre9.iff",
             }

}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_lightsaber_one_hand_gen2, "object/draft_schematic/weapon/lightsaber/lightsaber_one_hand_gen2.iff")
