MeatlumpCityRaid = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MeatlumpCityRaid",

	-- ======================
	-- CONFIGURATION
	-- ======================
	config = {
		minInterval = 3 * 60 * 60,
		maxInterval = 6 * 60 * 60,
		warningLeadTime = 30 * 60,
		raidDuration = 45 * 60,
		hotspotRadius = 35,
		waveCheckInterval = 15,
		waveCompleteThreshold = 3,
		announce = true,

		-- Bonus loot / credit multipliers by wave
		creditMultipliers = { [1] = 1.5, [2] = 2.0, [3] = 2.5 },
		extraLootChances = { [1] = 35, [2] = 50, [3] = 70 },
		extraLootLevelBonus = { [1] = 10, [2] = 20, [3] = 35 },
	},

	bonusLootGroups = {
		"wearables_common",
		"weapons_all",
		"armor_all",
		"junk",
		"attachments",
	},

	warningMessages = {
		[30] = "Rumors are spreading across Corellia... the Meatlumps are stirring. Whispers of coordinated mischief and sudden raids on city streets have begun to circulate. Citizens are advised to stay alert.",
		[15] = "The rumors grow louder. Meatlump scouts have been spotted near the outskirts of Corellia's cities. Something big is brewing.",
		[10] = "Tension rises across Corellia. Reports of Meatlump gatherings are coming in from multiple cities. The streets may not stay quiet for long.",
		[5]  = "This is not a drill. Meatlump forces are mobilizing. All citizens in Corellia's major cities should prepare for imminent chaos.",
	},

	cities = {
		{
			name = "Coronet",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -131,  y = -4723, z = 28 },
				{ x = -60,   y = -4599, z = 28 },
				{ x = -346,  y = -4542, z = 28 },
				{ x = -106,  y = -4461, z = 28 },
				{ x = -23,   y = -4401, z = 28 },
				{ x = -209,  y = -4534, z = 28 },
				{ x = -329,  y = -4636, z = 28 },
				{ x = -480,  y = -4499, z = 28 },
			},
		},
		{
			name = "Tyrena",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -5031, y = -2287, z = 21 },
				{ x = -5110, y = -2387, z = 21 },
				{ x = -5285, y = -2522, z = 21 },
				{ x = -5005, y = -2476, z = 21 },
				{ x = -5005, y = -2381, z = 21 },
				{ x = -5603, y = -2790, z = 21 },
				{ x = -5201, y = -2566, z = 21 },
			},
		},
		{
			name = "Bela Vistal",
			spawnMultiplier = 0.5,
			hotspots = {
				{ x = 6800,  y = -5700, z = 315 },
				{ x = 6735,  y = -5708, z = 315 },
				{ x = 6909,  y = -5581, z = 315 },
				{ x = 6637,  y = -5921, z = 315 },
				{ x = 6937,  y = -5536, z = 315 },
				{ x = 6853,  y = -5443, z = 315 },
			},
		},
		{
			name = "Doaba Guerfel",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = 3340,  y = 5534, z = 300 },
				{ x = 3207,  y = 5382, z = 300 },
				{ x = 3268,  y = 5373, z = 300 },
				{ x = 3262,  y = 5422, z = 300 },
				{ x = 3078,  y = 4995, z = 300 },
				{ x = 3108,  y = 5205, z = 300 },
			},
		},
		{
			name = "Kor Vella",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -3138, y = 2815, z = 86 },
				{ x = -3464, y = 3039, z = 86 },
				{ x = -3793, y = 3157, z = 86 },
				{ x = -3126, y = 2790, z = 86 },
				{ x = -3777, y = 3240, z = 86 },
				{ x = -3268, y = 3109, z = 86 },
				{ x = -3434, y = 3197, z = 86 },
			},
		},
	},

	waves = {
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_fool", "meatlump_fool", "meatlump_buffoon",
				"meatlump_stooge", "meatlump_oaf", "meatlump_clod",
			},
		},
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_clod", "meatlump_clod", "meatlump_cretin",
				"meatlump_loon", "meatlump_stooge", "meatlump_oaf",
			},
		},
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_clod", "meatlump_cretin", "meatlump_loon",
				"meatlump_loon", "meatlump_oaf", "meatlump_stooge",
			},
		},
	},
}

registerScreenPlay("MeatlumpCityRaid", true)

function MeatlumpCityRaid:start()
	if (not isZoneEnabled("corellia")) then
		return
	end

	local firstDelay = getRandomNumber(20 * 60, 45 * 60) * 1000
	createEvent(firstDelay, "MeatlumpCityRaid", "scheduleNextRaid", nil, "")
end

function MeatlumpCityRaid:scheduleNextRaid()
	local delay = getRandomNumber(self.config.minInterval, self.config.maxInterval) * 1000
	createEvent(delay, "MeatlumpCityRaid", "beginWarningSequence", nil, "")
end

function MeatlumpCityRaid:beginWarningSequence()
	self:broadcastWarning(30)

	createEvent(15 * 60 * 1000, "MeatlumpCityRaid", "warning15", nil, "")
	createEvent(20 * 60 * 1000, "MeatlumpCityRaid", "warning10", nil, "")
	createEvent(25 * 60 * 1000, "MeatlumpCityRaid", "warning5",  nil, "")
	createEvent(30 * 60 * 1000, "MeatlumpCityRaid", "startRaid", nil, "")
end

function MeatlumpCityRaid:warning15()
	self:broadcastWarning(15)
end

function MeatlumpCityRaid:warning10()
	self:broadcastWarning(10)
end

function MeatlumpCityRaid:warning5()
	self:broadcastWarning(5)
end

function MeatlumpCityRaid:broadcastWarning(minutes)
	local msg = self.warningMessages[minutes]
	if (msg ~= nil) then
		broadcastToGalaxy(msg)
	end

	if (self.config.announce) then
		print("[MeatlumpCityRaid] " .. minutes .. "-minute warning issued.")
	end
end

function MeatlumpCityRaid:startRaid()
	if (self.config.announce) then
		print("[MeatlumpCityRaid] Meatlumps are raiding all Corellia cities!")
	end

	broadcastToGalaxy("The Meatlumps have made their move! Chaotic bands of the infamous street gang have poured into the streets of every major city on Corellia. Defend the towns!")

	writeSharedMemory("MeatlumpCityRaid:active", "1")

	for _, city in ipairs(self.cities) do
		writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave", "1")
		writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done", "0")
		self:spawnWaveForCity(city, 1)
	end

	createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkAllCitiesProgress", nil, "")
	createEvent(self.config.raidDuration * 1000, "MeatlumpCityRaid", "cleanupRaid", nil, "")

	self:scheduleNextRaid()
end

function MeatlumpCityRaid:spawnWaveForCity(city, waveNumber)
	local waveDef = self.waves[waveNumber]
	if (waveDef == nil) then
		return
	end

	local multiplier = city.spawnMultiplier or 1.0
	local totalForCity = math.floor(getRandomNumber(waveDef.minCount, waveDef.maxCount) * multiplier)
	if (totalForCity < 5) then totalForCity = 5 end

	local hotspots = city.hotspots
	local numHotspots = #hotspots
	local basePerHotspot = math.floor(totalForCity / numHotspots)
	local remainder = totalForCity % numHotspots

	local cityOids = {}

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

			local pMobile = spawnMobile("corellia", template, 0, hotspot.x + offsetX, hotspot.z, hotspot.y + offsetY, getRandomNumber(0, 360), 0)

			if (pMobile ~= nil) then
				CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)

				local oid = SceneObject(pMobile):getObjectID()
				table.insert(cityOids, oid)

				writeData(oid .. ":raidWave", waveNumber)
				createObserver(OBJECTDESTRUCTION, "MeatlumpCityRaid", "onRaidMobDeath", pMobile)
			end
		end
	end

	writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids", table.concat(cityOids, ","))
	writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave", tostring(waveNumber))

	if (self.config.announce) then
		print("[MeatlumpCityRaid] Wave " .. waveNumber .. " spawned in " .. city.name .. " (" .. #cityOids .. " Meatlumps)")
	end
end

-- ======================
-- BONUS LOOT / CREDITS
-- ======================
function MeatlumpCityRaid:onRaidMobDeath(pVictim, pAttacker)
	if (pVictim == nil) then
		return 1
	end

	local oid = SceneObject(pVictim):getObjectID()
	local wave = readData(oid .. ":raidWave") or 1
	deleteData(oid .. ":raidWave")

	local multiplier = self.config.creditMultipliers[wave] or 1.5
	local extraChance = self.config.extraLootChances[wave] or 35
	local levelBonus = self.config.extraLootLevelBonus[wave] or 10

	local level = CreatureObject(pVictim):getLevel()
	if (level < 1) then level = 15 end

	local baseCredits = math.floor(level * 12 + getRandomNumber(40, 120))
	local bonusCredits = math.floor(baseCredits * (multiplier - 1.0))

	if (bonusCredits > 0) then
		CreatureObject(pVictim):addCashCredits(bonusCredits, true)
	end

	local pInventory = CreatureObject(pVictim):getSlottedObject("inventory")
	if (pInventory ~= nil) then
		if (getRandomNumber(1, 100) <= extraChance) then
			local lootLevel = level + levelBonus
			local group = self.bonusLootGroups[getRandomNumber(1, #self.bonusLootGroups)]
			createLoot(pInventory, group, lootLevel, true)
		end

		if (wave >= 3 and getRandomNumber(1, 100) <= math.floor(extraChance * 0.6)) then
			local lootLevel = level + levelBonus + 5
			local group = self.bonusLootGroups[getRandomNumber(1, #self.bonusLootGroups)]
			createLoot(pInventory, group, lootLevel, true)
		end
	end

	return 1
end

function MeatlumpCityRaid:checkAllCitiesProgress()
	if (readSharedMemory("MeatlumpCityRaid:active") ~= "1") then
		return
	end

	local anyStillActive = false

	for _, city in ipairs(self.cities) do
		local done = readSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done")
		if (done ~= "1") then
			anyStillActive = true
			self:checkCityProgress(city)
		end
	end

	if (anyStillActive) then
		createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkAllCitiesProgress", nil, "")
	else
		if (self.config.announce) then
			print("[MeatlumpCityRaid] All cities have cleared every wave!")
		end

		broadcastToGalaxy("The Meatlump assault has been driven back. The streets of Corellia's cities grow quieter once more... for now.")
		self:cleanupRaid()
	end
end

function MeatlumpCityRaid:checkCityProgress(city)
	local oidString = readSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids")
	if (oidString == nil or oidString == "") then
		self:advanceCity(city)
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
		self:advanceCity(city)
	end
end

function MeatlumpCityRaid:advanceCity(city)
	local currentWave = tonumber(readSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave")) or 1
	local nextWave = currentWave + 1

	if (self.waves[nextWave] ~= nil) then
		self:spawnWaveForCity(city, nextWave)
	else
		writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done", "1")
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids")

		if (self.config.announce) then
			print("[MeatlumpCityRaid] " .. city.name .. " has cleared all waves!")
		end
	end
end

function MeatlumpCityRaid:cleanupRaid()
	writeSharedMemory("MeatlumpCityRaid:active", "0")

	local totalRemaining = 0

	for _, city in ipairs(self.cities) do
		local oidString = readSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids")

		if (oidString ~= nil and oidString ~= "") then
			local oids = {}
			for oid in string.gmatch(oidString, "([^,]+)") do
				table.insert(oids, tonumber(oid))
			end

			for _, oid in ipairs(oids) do
				local pObj = getSceneObject(oid)
				if (pObj ~= nil and SceneObject(pObj):isCreatureObject() and not CreatureObject(pObj):isDead()) then
					SceneObject(pObj):destroyObjectFromWorld()
					totalRemaining = totalRemaining + 1
				end
				deleteData(oid .. ":raidWave")
			end
		end

		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids")
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave")
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done")
	end

	if (self.config.announce and totalRemaining > 0) then
		print("[MeatlumpCityRaid] Raid ended. " .. totalRemaining .. " remaining Meatlumps despawned.")
	end

	deleteSharedMemory("MeatlumpCityRaid:active")
end
