TuskenCityRaid = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TuskenCityRaid",

	-- ======================
	-- CONFIGURATION
	-- ======================
	config = {
		minInterval = 45 * 60,
		maxInterval = 90 * 60,
		warningLeadTime = 30 * 60,
		raidDuration = 35 * 60,
		hotspotRadius = 40,
		waveCheckInterval = 12,
		waveCompleteThreshold = 2,
		announce = true,

		-- Bonus loot / credit multipliers by wave
		-- Wave 1 = 1.5x, Wave 2 = 2.0x, Wave 3 = 2.5x
		creditMultipliers = { [1] = 1.5, [2] = 2.0, [3] = 2.5 },
		extraLootChances = { [1] = 35, [2] = 50, [3] = 70 },	-- % chance for an extra item
		extraLootLevelBonus = { [1] = 10, [2] = 20, [3] = 35 },	-- added to creature level for the extra item
	},

	-- Loot groups used for the *extra* raid bonus item(s)
	bonusLootGroups = {
		"wearables_common",
		"weapons_all",
		"armor_all",
		"junk",
		"attachments",
	},

	warningMessages = {
		[30] = "A dry wind carries strange whispers across Tatooine. Scouts report increased Tusken activity near the dunes surrounding %s. Travelers are urged to remain cautious.",
		[15] = "The desert grows restless. Multiple Tusken war bands have been sighted moving toward %s. The Sand People may be preparing a coordinated strike.",
		[10] = "Tension mounts around %s. Local outposts report Tusken war cries echoing from the surrounding wastes. An attack appears imminent.",
		[5]  = "This is not a false alarm. Tusken Raiders are massing on the approaches to %s. Citizens and visitors should prepare to defend the city.",
	},

	cities = {
		{
			name = "Bestine",
			hotspots = {
				{ x = -1374, y = -3629, z = 12 },
				{ x = -1258, y = -3641, z = 12 },
				{ x = -1006, y = -3544, z = 12 },
				{ x = -1359, y = -3688, z = 12 },
				{ x = -1300, y = -3501, z = 12 },
				{ x = -1091, y = -3554, z = 12 },
				{ x = -1422, y = -3782, z = 12 },
			},
		},
		{
			name = "Mos Eisley",
			hotspots = {
				{ x = 3608,  y = -4753, z = 5 },
				{ x = 3499,  y = -4944, z = 5 },
				{ x = 3468,  y = -4855, z = 5 },
				{ x = 3363,  y = -4586, z = 5 },
				{ x = 3514,  y = -4773, z = 5 },
				{ x = 3433,  y = -4658, z = 5 },
				{ x = 3423,  y = -5006, z = 5 },
				{ x = 3305,  y = -4769, z = 5 },
			},
		},
		{
			name = "Anchorhead",
			hotspots = {
				{ x =  38,   y = -5333, z = 52 },
				{ x = -156,  y = -5306, z = 52 },
				{ x =  70,   y = -5358, z = 52 },
				{ x = 123,   y = -5364, z = 52 },
				{ x = 141,   y = -5357, z = 52 },
			},
		},
		{
			name = "Mos Espa",
			hotspots = {
				{ x = -2809, y = 2129, z = 5 },
				{ x = -2969, y = 2322, z = 5 },
				{ x = -2991, y = 2124, z = 5 },
				{ x = -3150, y = 2125, z = 5 },
				{ x = -2793, y = 2179, z = 5 },
				{ x = -2886, y = 1930, z = 5 },
				{ x = -3114, y = 2166, z = 5 },
				{ x = -3093, y = 2271, z = 5 },
			},
		},
		{
			name = "Wayfar",
			hotspots = {
				{ x = -5174, y = -6582, z = 75 },
				{ x = -5150, y = -6588, z = 75 },
				{ x = -5273, y = -6549, z = 75 },
				{ x = -5123, y = -6616, z = 75 },
				{ x = -5050, y = -6627, z = 75 },
			},
		},
	},

	waves = {
		{
			minCount = 50,
			maxCount = 70,
			templates = {
				"tusken_raider", "tusken_raider", "tusken_raider", "tusken_raider",
				"tusken_warrior", "tusken_warrior", "tusken_sniper",
			},
		},
		{
			minCount = 35,
			maxCount = 50,
			templates = {
				"tusken_warrior", "tusken_warrior", "tusken_sniper", "tusken_sniper",
				"tusken_captain", "tusken_captain", "tusken_berserker", "tusken_berserker",
			},
		},
		{
			minCount = 20,
			maxCount = 30,
			templates = {
				"tusken_captain", "tusken_elite_guard", "tusken_berserker",
				"tusken_blood_champion", "tusken_carnage_champion",
				"tusken_raid_champion", "tusken_war_master",
			},
		},
	},
}

registerScreenPlay("TuskenCityRaid", true)

function TuskenCityRaid:start()
	if (not isZoneEnabled("tatooine")) then
		return
	end

	local firstDelay = getRandomNumber(5 * 60, 12 * 60) * 1000
	createEvent(firstDelay, "TuskenCityRaid", "scheduleNextRaid", nil, "")
end

function TuskenCityRaid:scheduleNextRaid()
	local delay = getRandomNumber(self.config.minInterval, self.config.maxInterval) * 1000
	createEvent(delay, "TuskenCityRaid", "beginWarningSequence", nil, "")
end

function TuskenCityRaid:beginWarningSequence()
	local city = self.cities[getRandomNumber(1, #self.cities)]
	writeSharedMemory("TuskenCityRaid:cityName", city.name)

	self:broadcastWarning(30)

	createEvent(15 * 60 * 1000, "TuskenCityRaid", "warning15", nil, "")
	createEvent(20 * 60 * 1000, "TuskenCityRaid", "warning10", nil, "")
	createEvent(25 * 60 * 1000, "TuskenCityRaid", "warning5",  nil, "")
	createEvent(30 * 60 * 1000, "TuskenCityRaid", "startRaid", nil, "")
end

function TuskenCityRaid:warning15()
	self:broadcastWarning(15)
end

function TuskenCityRaid:warning10()
	self:broadcastWarning(10)
end

function TuskenCityRaid:warning5()
	self:broadcastWarning(5)
end

function TuskenCityRaid:broadcastWarning(minutes)
	local cityName = readSharedMemory("TuskenCityRaid:cityName") or "a Tatooine settlement"
	local template = self.warningMessages[minutes]

	if (template ~= nil) then
		broadcastToGalaxy(string.format(template, cityName))
	end

	if (self.config.announce) then
		print("[TuskenCityRaid] " .. minutes .. "-minute warning issued for " .. cityName .. ".")
	end
end

function TuskenCityRaid:startRaid()
	local cityName = readSharedMemory("TuskenCityRaid:cityName")
	local city = self:getCityByName(cityName)

	if (city == nil) then
		city = self.cities[getRandomNumber(1, #self.cities)]
		writeSharedMemory("TuskenCityRaid:cityName", city.name)
	end

	if (self.config.announce) then
		print("[TuskenCityRaid] Tusken Raiders are attacking " .. city.name .. "!")
	end

	broadcastToGalaxy(string.format("The Sand People have struck! Tusken Raiders pour into the streets of %s. Defend the city!", city.name))

	writeSharedMemory("TuskenCityRaid:currentWave", "1")
	writeSharedMemory("TuskenCityRaid:active", "1")

	self:spawnWave(1)

	createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")
	createEvent(self.config.raidDuration * 1000, "TuskenCityRaid", "cleanupRaid", nil, "")

	self:scheduleNextRaid()
end

function TuskenCityRaid:getCityByName(name)
	for _, city in ipairs(self.cities) do
		if (city.name == name) then
			return city
		end
	end
	return nil
end

function TuskenCityRaid:spawnWave(waveNumber)
	local waveDef = self.waves[waveNumber]
	if (waveDef == nil) then
		return
	end

	local cityName = readSharedMemory("TuskenCityRaid:cityName")
	local city = self:getCityByName(cityName)

	if (city == nil) then
		return
	end

	local totalCount = getRandomNumber(waveDef.minCount, waveDef.maxCount)
	local hotspots = city.hotspots
	local numHotspots = #hotspots
	local basePerHotspot = math.floor(totalCount / numHotspots)
	local remainder = totalCount % numHotspots

	local spawnedOids = {}

	for h = 1, numHotspots do
		local countThisHotspot = basePerHotspot
		if (h <= remainder) then
			countThisHotspot = countThisHotspot + 1
		end

		local hotspot = hotspots[h]

		for i = 1, countThisHotspot do
			local template = waveDef.templates[getRandomNumber(1, #waveDef.templates)]
			local offsetX = getRandomNumber(-self.config.hotspotRadius, self.config.hotspotRadius)
			local offsetY = getRandomNumber(-self.config.hotspotRadius, self.config.hotspotRadius)

			local pMobile = spawnMobile("tatooine", template, 0, hotspot.x + offsetX, hotspot.z, hotspot.y + offsetY, getRandomNumber(0, 360), 0)

			if (pMobile ~= nil) then
				CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)

				local oid = SceneObject(pMobile):getObjectID()
				table.insert(spawnedOids, oid)

				-- Track which wave this mob belongs to + attach death observer for bonus loot
				writeData(oid .. ":raidWave", waveNumber)
				createObserver(OBJECTDESTRUCTION, "TuskenCityRaid", "onRaidMobDeath", pMobile)
			end
		end
	end

	writeSharedMemory("TuskenCityRaid:currentOids", table.concat(spawnedOids, ","))
	writeSharedMemory("TuskenCityRaid:currentWave", tostring(waveNumber))

	if (self.config.announce) then
		print("[TuskenCityRaid] Wave " .. waveNumber .. " spawned across " .. city.name .. " (" .. #spawnedOids .. " Tuskens)")
	end
end

-- ======================
-- BONUS LOOT / CREDITS
-- ======================
function TuskenCityRaid:onRaidMobDeath(pVictim, pAttacker)
	if (pVictim == nil) then
		return 1
	end

	local oid = SceneObject(pVictim):getObjectID()
	local wave = readData(oid .. ":raidWave") or 1
	deleteData(oid .. ":raidWave")

	local multiplier = self.config.creditMultipliers[wave] or 1.5
	local extraChance = self.config.extraLootChances[wave] or 35
	local levelBonus = self.config.extraLootLevelBonus[wave] or 10

	-- Extra credits on the corpse (scaled)
	-- Base approximates normal credit drop; we add the *bonus* portion so total feels like the multiplier
	local level = CreatureObject(pVictim):getLevel()
	if (level < 1) then level = 20 end

	local baseCredits = math.floor(level * 15 + getRandomNumber(50, 150))
	local bonusCredits = math.floor(baseCredits * (multiplier - 1.0))

	if (bonusCredits > 0) then
		CreatureObject(pVictim):addCashCredits(bonusCredits, true)
	end

	-- Chance for one (or on later waves, sometimes two) extra higher-level item(s) on the corpse
	local pInventory = CreatureObject(pVictim):getSlottedObject("inventory")
	if (pInventory ~= nil) then
		local roll = getRandomNumber(1, 100)
		if (roll <= extraChance) then
			local lootLevel = level + levelBonus
			local group = self.bonusLootGroups[getRandomNumber(1, #self.bonusLootGroups)]
			createLoot(pInventory, group, lootLevel, true)
		end

		-- Wave 3 gets a second chance at another item
		if (wave >= 3 and getRandomNumber(1, 100) <= math.floor(extraChance * 0.6)) then
			local lootLevel = level + levelBonus + 5
			local group = self.bonusLootGroups[getRandomNumber(1, #self.bonusLootGroups)]
			createLoot(pInventory, group, lootLevel, true)
		end
	end

	return 1
end

function TuskenCityRaid:checkWaveProgress()
	if (readSharedMemory("TuskenCityRaid:active") ~= "1") then
		return
	end

	local oidString = readSharedMemory("TuskenCityRaid:currentOids")
	if (oidString == nil or oidString == "") then
		self:advanceOrFinish()
		return
	end

	local oids = {}
	for oid in string.gmatch(oidString, "([^,]+)") do
		table.insert(oids, tonumber(oid))
	end

	local alive = 0
	for _, oid in ipairs(oids) do
		local pObj = getSceneObject(oid)
		if (pObj ~= nil and SceneObject(pObj):isCreatureObject() and not CreatureObject(pObj):isDead()) then
			alive = alive + 1
		end
	end

	if (alive <= self.config.waveCompleteThreshold) then
		self:advanceOrFinish()
	else
		createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")
	end
end

function TuskenCityRaid:advanceOrFinish()
	local currentWave = tonumber(readSharedMemory("TuskenCityRaid:currentWave")) or 1
	local nextWave = currentWave + 1

	if (self.waves[nextWave] ~= nil) then
		self:spawnWave(nextWave)
		createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")
	else
		if (self.config.announce) then
			print("[TuskenCityRaid] All waves defeated at " .. (readSharedMemory("TuskenCityRaid:cityName") or "the city") .. "!")
		end

		broadcastToGalaxy(string.format("The Tusken assault on %s has been driven back into the desert. For now, the city stands.", readSharedMemory("TuskenCityRaid:cityName") or "the city"))
		self:cleanupRaid()
	end
end

function TuskenCityRaid:cleanupRaid()
	writeSharedMemory("TuskenCityRaid:active", "0")

	local oidString = readSharedMemory("TuskenCityRaid:currentOids")
	local cityName = readSharedMemory("TuskenCityRaid:cityName") or "a city"

	if (oidString ~= nil and oidString ~= "") then
		local oids = {}
		for oid in string.gmatch(oidString, "([^,]+)") do
			table.insert(oids, tonumber(oid))
		end

		local remaining = 0
		for _, oid in ipairs(oids) do
			local pObj = getSceneObject(oid)
			if (pObj ~= nil and SceneObject(pObj):isCreatureObject() and not CreatureObject(pObj):isDead()) then
				SceneObject(pObj):destroyObjectFromWorld()
				remaining = remaining + 1
			end
			deleteData(oid .. ":raidWave")
		end

		if (self.config.announce and remaining > 0) then
			print("[TuskenCityRaid] Raid at " .. cityName .. " ended. " .. remaining .. " remaining Tuskens despawned.")
		end
	end

	deleteSharedMemory("TuskenCityRaid:currentOids")
	deleteSharedMemory("TuskenCityRaid:cityName")
	deleteSharedMemory("TuskenCityRaid:currentWave")
	deleteSharedMemory("TuskenCityRaid:active")
end
