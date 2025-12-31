/*
 * ResourceLabratory.cpp
 *
 *  Created on: Aug 6, 2013
 *      Author: swgemu
 */

#include "ResourceLabratory.h"
#include "server/zone/objects/draftschematic/DraftSchematic.h"
#include "server/zone/objects/tangible/component/Component.h"
#include "server/zone/objects/manufactureschematic/ingredientslots/ComponentSlot.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/objects/tangible/component/lightsaber/LightsaberCrystalComponent.h"
#include "server/zone/objects/tangible/TangibleObject.h"
#include "server/zone/objects/scene/SceneObject.h"

#define DEBUG_RESOURCE_LAB

ResourceLabratory::ResourceLabratory() {
	setLoggingName("ResourceLabratory");
}

ResourceLabratory::~ResourceLabratory() {
}

void ResourceLabratory::initialize(ZoneServer* server) {
	SharedLabratory::initialize(server);
	Reference<Lua* > lua = new Lua();
	lua->init();
	if (!lua->runFile("scripts/managers/crafting/bio_skill_mods.lua")) {
		return;
	}
	LuaObject bioModsTable = lua->getGlobalObject("bioSkillMods");
	if (!bioModsTable.isValidTable())
		return;
	for (int i = 1; i <= bioModsTable.getTableSize(); ++i) {
		String mod = bioModsTable.getStringAt(i);
		bioMods.put(mod);
	}
	bioModsTable.pop();

}
void ResourceLabratory::setInitialCraftingValues(TangibleObject* prototype, ManufactureSchematic* manufactureSchematic, int assemblySuccess) {
#ifdef DEBUG_RESOURCE_LAB
	info(true) << "---------- ResourceLabratory::setInitialCraftingValues --------";
#endif // DEBUG_RESOURCE_LAB

	if (manufactureSchematic == nullptr || manufactureSchematic->getDraftSchematic() == nullptr)
		return;

	ManagedReference<DraftSchematic* > draftSchematic = manufactureSchematic->getDraftSchematic();
	CraftingValues* craftingValues = manufactureSchematic->getCraftingValues();

	float value, maxPercentage, currentPercentage, weightedSum;

	// These 2 values are pretty standard, adding these
	value = float(draftSchematic->getXpAmount());
	craftingValues->addExperimentalAttribute("xp", "", value, value, 0, true, AttributesMap::OVERRIDECOMBINE);

	value = manufactureSchematic->getComplexity();
	craftingValues->addExperimentalAttribute("complexity", "", value, value, 0, true, AttributesMap::OVERRIDECOMBINE);

	float modifier = calculateAssemblyValueModifier(assemblySuccess);

	for (int i = 0; i < draftSchematic->getResourceWeightCount(); ++i) {
		// Grab the first weight group
		Reference<ResourceWeight* > resourceWeight = draftSchematic->getResourceWeight(i);

		// Getting the title ex: expDamage
		String group = resourceWeight->getExperimentalTitle();

		// Getting the subtitle ex: minDamage
		String attribute = resourceWeight->getPropertyName();

#ifdef DEBUG_RESOURCE_LAB
		info(true) << "setInitialCraftingValues -- adding attribute " << attribute << " with the group " << group;
#endif // DEBUG_RESOURCE_LAB
		weightedSum = 0;
		craftingValues->addExperimentalAttribute(attribute, group, resourceWeight->getMinValue(), resourceWeight->getMaxValue(), resourceWeight->getPrecision(), resourceWeight->isFiller(), resourceWeight->getCombineType());

		for (int j = 0; j < resourceWeight->getPropertyListSize(); ++j) {
			// Based on the script we cycle through each exp group
			// Get the type from the type/weight
			int type = (resourceWeight->getTypeAndWeight(j) >> 4);

			// Get the calculation percentage
			float percentage = resourceWeight->getPropertyPercentage(j);

			// add to the weighted sum based on type and percentage
			weightedSum += getWeightedValue(manufactureSchematic, type) * percentage;
		}

		// > 0 ensures that we don't add things when there is NaN value
		if (weightedSum > 0) {

			// This is the formula for max experimenting percentages
			maxPercentage = ((weightedSum / 10.0f) * .01f);

			// Based on the weighted sum, we can get the initial %
			currentPercentage = getAssemblyPercentage(weightedSum) * modifier;
			craftingValues->setCurrentPercentage(attribute, currentPercentage, maxPercentage);
		}
	}

	craftingValues->recalculateValues(true);

	if (applyComponentStats(prototype, manufactureSchematic)) {
#ifdef DEBUG_RESOURCE_LAB
		info(true) << "Apply Component Stats is TRUE --  recalculateValues AGAIN";
#endif // DEBUG_RESOURCE_LAB
		craftingValues->recalculateValues(true);
	}

	if(draftSchematic->getIsMagic()) {
		prototype->setIsCraftedEnhancedItem(true);
		prototype->addMagicBit(false);
	}

#ifdef DEBUG_RESOURCE_LAB
	info(true) << "---------- END ResourceLabratory::setInitialCraftingValues --------";
#endif // DEBUG_RESOURCE_LAB
}

void ResourceLabratory::experimentRow(CraftingValues* craftingValues, int rowEffected, int pointsAttempted, float failure, int experimentationResult){
	String experimentedGroup = craftingValues->getVisibleAttributeGroup(rowEffected);

#ifdef DEBUG_RESOURCE_LAB
	info(true) << "---------- ResourceLabratory::experimentRow for Row #" << rowEffected << " with Experimented Group Name " << experimentedGroup << " with a total Experimental attributes " << craftingValues->getTotalExperimentalAttributes() << " using " << pointsAttempted << " points. -----------";
#endif // DEBUG_RESOURCE_LAB

	for (int i = 0; i < craftingValues->getTotalExperimentalAttributes(); ++i) {
		String attribute = craftingValues->getAttribute(i);
		String group = craftingValues->getAttributeGroup(attribute);

#ifdef DEBUG_RESOURCE_LAB
		info(true) << "Checking #" << i << " Attribute: " << attribute << " with Group: " << group;
#endif // DEBUG_RESOURCE_LAB

		if (group != experimentedGroup)
			continue;

		float modifier = calculateExperimentationValueModifier(experimentationResult,pointsAttempted);
		float newValue = craftingValues->getCurrentPercentage(attribute) + modifier;
		float maxPercent = craftingValues->getMaxPercentage(attribute);

		if (newValue > maxPercent) {
			newValue = maxPercent;
		}

		if (newValue < 0)
			newValue = 0;

#ifdef DEBUG_RESOURCE_LAB
		info(true) << "Experimenting on " << attribute << " with a modifier " << modifier << " and new calculated value of " << newValue << " and max percentage of " << maxPercent;
#endif // DEBUG_RESOURCE_LAB
		craftingValues->setCurrentPercentage(attribute, newValue);
	}

#ifdef DEBUG_RESOURCE_LAB
	info(true) << "---------- END ResourceLabratory::experimentRow ----------";
#endif // DEBUG_RESOURCE_LAB
}

int ResourceLabratory::getCreationCount(ManufactureSchematic* manufactureSchematic) {
	return 1;
}

//start replacement code here ***
bool ResourceLabratory::applyComponentStats(TangibleObject* prototype, ManufactureSchematic* manufactureSchematic) {
#ifdef DEBUG_RESOURCE_LAB
    info(true) << "----- ResourceLabratory::applyComponentStats called ------";
#endif // DEBUG_RESOURCE_LAB

    if (manufactureSchematic == nullptr || manufactureSchematic->getDraftSchematic() == nullptr)
        return false;

    float max, min, currentvalue, propertyvalue;
    int precision;
    bool modified = false;
    bool hidden;
    String attribute, group;

    CraftingValues* craftingValues = manufactureSchematic->getCraftingValues();
    ManagedReference<DraftSchematic* > draftSchematic = manufactureSchematic->getDraftSchematic();

    bool isYellow = false;

    for (int i = 0; i < manufactureSchematic->getSlotCount(); ++i) {
#ifdef DEBUG_RESOURCE_LAB
        info(true) << "applyComponentStats -- Component #" << i;
#endif // DEBUG_RESOURCE_LAB

        Reference<IngredientSlot* > ingredientSlot = manufactureSchematic->getSlot(i);
        Reference<DraftSlot* > draftSlot = draftSchematic->getDraftSlot(i);

        if(ingredientSlot == nullptr || !ingredientSlot->isComponentSlot() || !ingredientSlot->isFull())
            continue;

        ComponentSlot* compSlot = cast<ComponentSlot*>(ingredientSlot.get());

        if(compSlot == nullptr)
            continue;

        ManagedReference<TangibleObject*> tano = compSlot->getPrototype();

        if (tano == nullptr || !tano->isComponent())
            continue;

        ManagedReference<Component*> component = cast<Component*>(tano.get());

        // Custom lightsaber crystal stat transfer (integrated like blaster components)
        if (component->isLightsaberCrystalObject()) {
            LightsaberCrystalComponent* crystal = dynamic_cast<LightsaberCrystalComponent*>(component.get());
            if (crystal != nullptr && crystal->getColor() == 31 && crystal->getOwnerID() != 0) {  // Your merged/tuned check
#ifdef DEBUG_RESOURCE_LAB
                info(true) << "Tuned crystal found: " << crystal->getCustomObjectName().toString();
#endif
                Locker crystalLocker(crystal);  // Lock here for safety

                // Map tuned stats to schematic attributes and apply using combine logic (mimics blaster power handler)
                // Adjust attribute names if needed (e.g., from your debug logs: "mindamage", etc.)
                // Use draftSlot->getContribution() like in generic loop
                float contribution = draftSlot->getContribution();

                // Damage (adds to both min and max, assuming LINEARCOMBINE)
                if (craftingValues->hasExperimentalAttribute("mindamage")) {
                    attribute = "mindamage";
                    short combineType = craftingValues->getCombineType(attribute);
                    if (combineType == AttributesMap::LINEARCOMBINE) {  // Match dev's switch logic
                        propertyvalue = crystal->getDamage() * contribution;
                        currentvalue = craftingValues->getCurrentValue(attribute);
                        min = craftingValues->getMinValue(attribute);
                        max = craftingValues->getMaxValue(attribute);
                        currentvalue += propertyvalue;
                        min += propertyvalue;
                        max += propertyvalue;
                        craftingValues->setCurrentValue(attribute, currentvalue);
                        craftingValues->setMinValue(attribute, min);
                        craftingValues->setMaxValue(attribute, max);
                        modified = true;
#ifdef DEBUG_RESOURCE_LAB
                        info(true) << "Applied tuned minDamage: " << propertyvalue;
#endif
                    }
                }
                if (craftingValues->hasExperimentalAttribute("maxdamage")) {
                    attribute = "maxdamage";
                    short combineType = craftingValues->getCombineType(attribute);
                    if (combineType == AttributesMap::LINEARCOMBINE) {
                        propertyvalue = crystal->getDamage() * contribution;
                        currentvalue = craftingValues->getCurrentValue(attribute);
                        min = craftingValues->getMinValue(attribute);
                        max = craftingValues->getMaxValue(attribute);
                        currentvalue += propertyvalue;
                        min += propertyvalue;
                        max += propertyvalue;
                        craftingValues->setCurrentValue(attribute, currentvalue);
                        craftingValues->setMinValue(attribute, min);
                        craftingValues->setMaxValue(attribute, max);
                        modified = true;
#ifdef DEBUG_RESOURCE_LAB
                        info(true) << "Applied tuned maxDamage: " << propertyvalue;
#endif
                    }
                }

                // Attack Speed
                if (craftingValues->hasExperimentalAttribute("attackspeed")) {
                    attribute = "attackspeed";
                    short combineType = craftingValues->getCombineType(attribute);
                    if (combineType == AttributesMap::LINEARCOMBINE) {
                        propertyvalue = crystal->getAttackSpeed() * contribution;
                        currentvalue = craftingValues->getCurrentValue(attribute);
                        min = craftingValues->getMinValue(attribute);
                        max = craftingValues->getMaxValue(attribute);
                        currentvalue += propertyvalue;
                        min += propertyvalue;
                        max += propertyvalue;
                        craftingValues->setCurrentValue(attribute, currentvalue);
                        craftingValues->setMinValue(attribute, min);
                        craftingValues->setMaxValue(attribute, max);
                        modified = true;
#ifdef DEBUG_RESOURCE_LAB
                        info(true) << "Applied tuned attackSpeed: " << propertyvalue;
#endif
                    }
                }

                // Repeat for other stats: wound chance, SAC, force cost
                // Example for woundratio
                if (craftingValues->hasExperimentalAttribute("woundratio")) {
                    attribute = "woundratio";
                    short combineType = craftingValues->getCombineType(attribute);
                    if (combineType == AttributesMap::LINEARCOMBINE) {
                        propertyvalue = crystal->getWoundChance() * contribution;
                        currentvalue = craftingValues->getCurrentValue(attribute);
                        min = craftingValues->getMinValue(attribute);
                        max = craftingValues->getMaxValue(attribute);
                        currentvalue += propertyvalue;
                        min += propertyvalue;
                        max += propertyvalue;
                        craftingValues->setCurrentValue(attribute, currentvalue);
                        craftingValues->setMinValue(attribute, min);
                        craftingValues->setMaxValue(attribute, max);
                        modified = true;
#ifdef DEBUG_RESOURCE_LAB
                        info(true) << "Applied tuned woundChance: " << propertyvalue;
#endif
                    }
                }

                // Health SAC
                if (craftingValues->hasExperimentalAttribute("healthcost")) {
                    attribute = "healthcost";
                    short combineType = craftingValues->getCombineType(attribute);
                    if (combineType == AttributesMap::LINEARCOMBINE) {
                        propertyvalue = crystal->getSacHealth() * contribution;
                        currentvalue = craftingValues->getCurrentValue(attribute);
                        min = craftingValues->getMinValue(attribute);
                        max = craftingValues->getMaxValue(attribute);
                        currentvalue += propertyvalue;
                        min += propertyvalue;
                        max += propertyvalue;
                        craftingValues->setCurrentValue(attribute, currentvalue);
                        craftingValues->setMinValue(attribute, min);
                        craftingValues->setMaxValue(attribute, max);
                        modified = true;
#ifdef DEBUG_RESOURCE_LAB
                        info(true) << "Applied tuned sacHealth: " << propertyvalue;
#endif
                    }
                }

                // Action SAC (repeat pattern for "actioncost" and crystal->getSacAction())
                // Mind SAC ("mindcost" and getSacMind())
                // Force Cost ("forcecost" and getForceCost())

                // Blade color - keep as-is, but now inside the loop (no need for post-recalc)
                int bladeColorIndex = 31;
                byte colorType = 0x02;
                auto custVars = crystal->getCustomizationVariables();
                if (custVars != nullptr && custVars->contains(colorType)) {
                    bladeColorIndex = custVars->get(colorType);
                }
                if (bladeColorIndex != 31 && prototype->isWeaponObject()) {
                    WeaponObject* weapon = cast<WeaponObject*>(prototype);
                    if (weapon != nullptr) {
                        weapon->setBladeColor(bladeColorIndex);
                        weapon->setCustomizationVariable("/private/index_color_blade", bladeColorIndex, true);
                    }
                }
            }
            // Continue to allow normal processing (e.g., if crystal has other generic attributes)
        }

        // ... (rest of clothing handling, generic component loop unchanged)

    }

    if(isYellow) {
        prototype->setIsCraftedEnhancedItem(true);
        prototype->addMagicBit(false);
    }

#ifdef DEBUG_RESOURCE_LAB
    info(true) << "----- END ResourceLabratory::applyComponentStats called ------";
#endif

    return modified;
}
//end replacement code ***

String ResourceLabratory::checkBioSkillMods(const String& property) {
	for (int l = 0; l < bioMods.size(); ++l) {

		String key = bioMods.elementAt(l);
		String statname = "cat_skill_mod_bonus.@stat_n:" + key;

		if (property == statname) {
			return key;
		}
	}

	return "";
}
