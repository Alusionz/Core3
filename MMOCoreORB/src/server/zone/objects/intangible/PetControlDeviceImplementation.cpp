#include "server/zone/objects/intangible/PetControlDevice.h"
#include "server/zone/objects/intangible/PetControlObserver.h"
#include "server/zone/objects/intangible/tasks/EnqueuePetCommand.h"
#include "server/zone/managers/creature/PetManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/creature/ai/AiAgent.h"
#include "server/zone/objects/creature/ai/Creature.h"
#include "server/zone/objects/creature/ai/DroidObject.h"
#include "server/zone/objects/creature/ai/HelperDroidObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"
#include "server/zone/objects/player/sui/callbacks/MountGrowthArrestSuiCallback.h"
#include "server/zone/objects/player/sui/callbacks/PetFixSuiCallback.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/Zone.h"
#include "tasks/CallPetTask.h"
#include "server/zone/objects/region/CityRegion.h"
#include "server/zone/objects/player/sessions/TradeSession.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/creature/events/DroidSkillModTask.h"
#include "server/zone/objects/creature/events/DroidPowerTask.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/managers/stringid/StringIdManager.h"
#include "tasks/StorePetTask.h"
#include "server/chat/ChatManager.h"
#include "server/zone/objects/player/FactionStatus.h"
#include "server/zone/managers/frs/FrsManager.h"
#include "server/zone/objects/creature/commands/QueueCommand.h"
#include "server/zone/objects/intangible/tasks/PetControlDeviceStoreTask.h"

void PetControlDeviceImplementation::callObject(CreatureObject* player, bool initialCall) {
	if (player == nullptr) {
		return;
	}

	if (!isASubChildOf(player)) {
		return;
	}

	// Player is Dead or currently taming a pet
	if (player->isDead() || player->getPendingTask("tame_pet") != nullptr) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
		return;
	}

	// Private Building Check
	auto parent = player->getParent().get();

	if (parent != nullptr && !parent->isMount() && !parent->isVehicleObject()) {
		ManagedReference<SceneObject*> strongRef = player->getRootParent();

		if (strongRef != nullptr && !strongRef->isPobShip()) {
			ManagedReference<BuildingObject*> building = strongRef.castTo<BuildingObject*>();

			if (building == nullptr || building->isPrivateStructure()) {
				player->sendSystemMessage("@pet/pet_menu:private_house"); // You cannot call pets in a private building.
				return;
			}
		}
	}

	auto zoneServer = player->getZoneServer();

	if (zoneServer == nullptr) {
		return;
	}

	// Player is in FRS Enclave Check
	FrsManager* frsManager = zoneServer->getFrsManager();

	if (frsManager == nullptr || (frsManager->isFrsEnabled() && frsManager->isPlayerInEnclave(player))) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); //  You cannot call this pet right now.
		return;
	}

	ManagedReference<TangibleObject*> controlledObject = this->controlledObject.get();

	if (controlledObject == nullptr || !controlledObject->isAiAgent()) {
		return;
	}

	ManagedReference<AiAgent*> pet = cast<AiAgent*>(controlledObject.get());

	if (pet == nullptr) {
		return;
	}

	ManagedReference<PlayerObject*> ghost = player->getPlayerObject();

	if (ghost == nullptr || ghost->hasActivePet(pet)) {
		return;
	}

	if (pet->getDefaultWeapon() == nullptr) {
		pet->createDefaultWeapon();
		player->sendSystemMessage("This pet does not have a proper default weapon, attempting to create one. Please call your pet again.");

		return;
	}

	// This should never trigger, pet vitality should never drop below 1
	if (vitality <= 0) {
		player->sendSystemMessage("@pet/pet_menu:dead_pet"); // This pet is dead. Select DESTROY from the radial menu to delete this pet control device.
		return;
	}

	if (!pet->checkCooldownRecovery("call_cooldown")) {
		if (petType == PetManager::DROIDPET)
			player->sendSystemMessage("@pet/droid_modules:droid_maint_on_maint_run"); //You cannot call that droid. It is currently on a maintenance run.
		else
			player->sendSystemMessage("@pet/pet_menu:cant_call"); // cant call pet right now
		return;
	}

	bool isBombDroid = false;

	// Bomb Droid bool only can be true on initial call
	if (pet->isDroid()) {
		auto droid = pet.castTo<DroidObject*>();

		if (droid != nullptr && droid->isBombDroid()) {
			isBombDroid = true;
		}
	}

	// No Pet active area check
	if (!isBombDroid) {
		SortedVector<ManagedReference<ActiveArea*> >* areas = player->getActiveAreas();

		for (int i = 0; i < areas->size(); i++) {
			ActiveArea* area = areas->get(i);

			if (area != nullptr && area->isNoPetArea()) {
				player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
				return;
			}
		}
	}

	// Only Bomb droids can be called while in combat and while feigning death
	if ((((isBombDroid && !initialCall) || !isBombDroid) && (player->isInCombat() || player->isIncapacitated())) || (isBombDroid && initialCall && player->isIncapacitated() && !player->isFeigningDeath())) {
		player->sendSystemMessage("@pet/pet_menu:cant_call"); // You cannot call this pet right now.
		return;
	}

	// Bomb Droids can be called while riding a mount only when direct from deed form
	if (((isBombDroid && !initialCall) || !isBombDroid) && player->isRidingMount()) {
		player->sendSystemMessage("@pet/pet_menu:mounted_call_warning"); // You cannot call a pet while mounted or riding a vehicle.
		return;
	}

	unsigned int petFaction = pet->getFaction();

	if (petFaction != 0) {
		if (player->getFaction() == 0) {
			StringIdChatParameter message("@faction_perk:prose_be_declared"); // You must be declared to a faction to use %TT.
			message.setTT(pet->getDisplayedName());
			player->sendSystemMessage(message);
			return;
		}

		if (ConfigManager::instance()->useCovertOvertSystem()) {
			if (player->getFaction() != petFaction || player->getFactionStatus() != FactionStatus::OVERT) {
				StringIdChatParameter message("@faction_perk:prose_be_declared_faction"); // You must be a declared %TO to use %TT.
				message.setTO(pet->getFactionString());
				message.setTT(pet->getDisplayedName());
				player->sendSystemMessage(message);
				return;
			}
		} else {
			if (player->getFaction() != petFaction || player->getFactionStatus() == FactionStatus::ONLEAVE) {
				StringIdChatParameter message("@faction_perk:prose_be_declared_faction"); // You must be a declared %TO to use %TT.
				message.setTO(pet->getFactionString());
				message.setTT(pet->getDisplayedName());
				player->sendSystemMessage(message);
				return;
			}
		}
	}

	if (player->getPendingTask("call_pet") != nullptr) {
		StringIdChatParameter waitTime("pet/pet_menu", "call_delay_finish_pet"); // Already calling a Pet: Call will be finished in %DI seconds.
		AtomicTime nextExecution;
		Core::getTaskManager()->getNextExecutionTime(player->getPendingTask("call_pet"), nextExecution);
		int timeLeft = (nextExecution.getMiliTime() / 1000) - System::getTime();
		waitTime.setDI(timeLeft);

		player->sendSystemMessage(waitTime);
		return;
	}

	if (!growPet(player))
		return;

	if (petType == PetManager::CREATUREPET && !isValidPet(pet)) {
		ManagedReference<SuiMessageBox*> box = new SuiMessageBox(player,SuiWindowType::PET_FIX_DIALOG);
		box->setCallback(new PetFixSuiCallback(player->getZoneServer(), _this.getReferenceUnsafeStaticCast()));
		box->setPromptText("@bio_engineer:pet_sui_text");
		box->setPromptTitle("@bio_engineer:pet_sui_title");
		box->setOkButton(true,"@bio_engineer:pet_sui_fix_stats");
		box->setCancelButton(true,"@bio_engineer:pet_sui_abort");
		box->setOtherButton(true,"@bio_engineer:pet_sui_fix_level");
		box->setUsingObject(_this.getReferenceUnsafeStaticCast());
		ghost->addSuiBox(box);
		player->sendMessage(box->generateMessage());
		return;
	}

	int currentlySpawned = 0;
	int spawnedLevel = 0;
	int maxPets = 1;
	int maxLevelofPets = 10;
	int level = pet->getLevel();

	if (pet->getCreatureTemplate() == nullptr) {
		player->sendSystemMessage("Invalid creature to spawn!"); // Old npc without a npc template?
		return;
	}

	if (petType == PetManager::CREATUREPET) {
		ManagedReference<Creature*> creaturePet = cast<Creature*>(pet.get());

		if (creaturePet == nullptr)
			return;

		bool ch = player->hasSkill("outdoors_creaturehandler_novice");

		if (ch) {
			maxPets = player->getSkillMod("keep_creature");
			maxLevelofPets = player->getSkillMod("tame_level");
		}

		if (creaturePet->getAdultLevel() > maxLevelofPets) {
			player->sendSystemMessage("@pet/pet_menu:control_exceeded"); // Calling this pet would exceed your Control Level ability.
			return;
		}

		if (creaturePet->isVicious() && (player->getSkillMod("tame_aggro") <= 0 || !ch)) {
			player->sendSystemMessage("@pet/pet_menu:lack_skill"); // You lack the skill to call a pet of this type.
			return;
		}

	} else if (petType == PetManager::FACTIONPET){
		maxPets = 3;
	}

	for (int i = 0; i < ghost->getActivePetsSize(); ++i) {
		ManagedReference<AiAgent*> object = ghost->getActivePet(i);

		if (object != nullptr) {
			if (object->isCreature() && petType == PetManager::CREATUREPET) {
				const CreatureTemplate* activePetTemplate = object->getCreatureTemplate();

				if (activePetTemplate == nullptr || activePetTemplate->getTemplateName() == "at_st")
					continue;

				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
				// Pre-P9 / launch style: max_level_of_pets is per-pet (checked above via adult level).
				// Cumulative level sum removed so 3 full-grown high-CL pets are allowed.
			} else if (object->isNonPlayerCreatureObject() && petType == PetManager::FACTIONPET) {
				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			} else if (object->isCreature() && petType == PetManager::FACTIONPET) {
				// AT-ST and other creature-type faction pets count toward the normal maxPets = 3 limit
				const CreatureTemplate* activePetTemplate = object->getCreatureTemplate();

				if (activePetTemplate == nullptr)
					continue;

				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			} else if (object->isDroidObject() && petType == PetManager::DROIDPET) {
				if (++currentlySpawned >= maxPets) {
					player->sendSystemMessage("@pet/pet_menu:at_max"); // You already have the maximum number of pets of this type that you can call.
					return;
				}
			}

		}
	}

	ManagedReference<TradeSession*> tradeContainer = player->getActiveSession(SessionFacadeType::TRADE).castTo<TradeSession*>();

	if (tradeContainer != nullptr) {
		server->getZoneServer()->getPlayerManager()->handleAbortTradeMessage(player);
	}

	if (player->getCurrentCamp() == nullptr && player->getCityRegion() == nullptr && !ghost->isPrivileged() && !isBombDroid) {
		Reference<CallPetTask*> callPet = new CallPetTask(_this.getReferenceUnsafeStaticCast(), player, "call_pet");

		StringIdChatParameter message("pet/pet_menu", "call_pet_delay"); // Calling pet in %DI seconds. Combat will terminate pet call.
		message.setDI(15);
		player->sendSystemMessage(message);

		player->addPendingTask("call_pet", callPet, 15 * 1000);

		if (petControlObserver == nullptr) {
			petControlObserver = new PetControlObserver(_this.getReferenceUnsafeStaticCast());
			petControlObserver->deploy();
		}

		player->registerObserver(ObserverEventType::STARTCOMBAT, petControlObserver);
	} else { // Player is in a city or camp or the player is calling a bomb droid from a deed, spawn pet immediately
		// Check cooldown
		if (!player->checkCooldownRecovery("petCallOrStoreCooldown")) {
			player->sendSystemMessage("@pet/pet_menu:cant_call_1sec"); //"You cannot CALL for 1 second."
			return;
		}

		spawnObject(player);

		// Set cooldown
		player->updateCooldownTimer("petCallOrStoreCooldown", 1000); // 1 sec
	}

	EnqueuePetCommand* enqueueCommand = new EnqueuePetCommand(pet, String("petFollow").toLowerCase().hashCode(), String::valueOf(player->getObjectID()), player->getObjectID(), QueueCommand::NORMAL);
	enqueueCommand->schedule(50);
}
