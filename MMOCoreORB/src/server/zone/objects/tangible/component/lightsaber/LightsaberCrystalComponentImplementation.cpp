/*
 * LightsaberCrystalComponentImplementation.cpp
 *
 *  Created on: Jan 10, 2013 / Pre-P9 updates
 */

#include "server/zone/objects/tangible/component/lightsaber/LightsaberCrystalComponent.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/zone/objects/tangible/component/lightsaber/LightsaberCrystalTuneSuiCallback.h"
#include "server/zone/managers/stringid/StringIdManager.h"
#include "server/zone/objects/tangible/container/wearable/WearableContainerObject.h"

void LightsaberCrystalComponentImplementation::initializeTransientMembers() {
	ComponentImplementation::initializeTransientMembers();
}

void LightsaberCrystalComponentImplementation::notifyLoadFromDatabase() {
	ComponentImplementation::notifyLoadFromDatabase();

	if (getColor() == 0) {
		setColor(31);
		updateCrystal(31);
	}
}
