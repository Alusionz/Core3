TuskenCityRaid = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TuskenCityRaid",

	-- ======================
	-- CONFIGURATION
	-- ======================
	config = {
		-- Time between full raids (in seconds)
		minInterval = 45 * 60,		-- 45 minutes
		maxInterval = 90 * 60,		-- 90 minutes

		-- Maximum total duration of a raid before remaining Tuskens are force-despawned
		raidDuration = 35 * 60,		-- 35 minutes safety net (bigger raid)

		-- Random offset radius around each hotspot (meters)
		hotspotRadius = 40,

		-- How often (seconds) to check if the current wave is mostly dead
		waveCheckInterval = 12,

		-- Wave is considered complete when this many or fewer remain alive
		waveCompleteThreshold = 2,

		-- Print server log messages
		announce = true,
	},

	-- Cities that can be raided, each with multiple high-traffic hotspots
	cities = {
		{
			name = "Bestine",
			hotspots = {
				{ x = -1374, y = -3629, z = 12 },	-- Starport
				{ x = -1258, y = -3641, z = 12 },	-- Bank
				{ x = -1006, y = -3544, z = 12 },	-- Cantina (east)
				{ x = -1359, y = -3688, z = 12 },	-- Cantina (west)
				{ x = -1300, y = -3501, z = 12 },	-- Medical Center
				{ x = -1091, y = -3554, z = 12 },	-- Shuttleport
				{ x = -1422, y = -3782, z = 12 },	-- Cloning / southern edge
			},
		},
		{
			name = "Mos Eisley",
			hotspots = {
				{ x = 3608,  y = -4753, z = 5 },	-- Starport
				{ x = 3499,  y = -4944, z = 5 },	-- Bank
				{ x = 3468,  y = -4855, z = 5 },	-- Main Cantina
				{ x = 3363,  y = -4586, z = 5 },	-- Lucky Despot Cantina
				{ x = 3514,  y = -4773, z = 5 },	-- Medical Center
				{ x = 3433,  y = -4658, z = 5 },	-- Shuttleport
				{ x = 3423,  y = -5006, z = 5 },	-- Cloning (south)
				{ x = 3305,  y = -4769, z = 5 },	-- Theater / western side
			},
		},
		{
			name = "Anchorhead",
			hotspots = {
				{ x =  38,   y = -5333, z = 52 },	-- Shuttleport
				{ x = -156,  y = -5306, z = 52 },	-- Cantina
				{ x =  70,   y = -5358, z = 52 },	-- Cloning Facility
				{ x = 123,   y = -5364, z = 52 },	-- Tavern / center
				{ x = 141,   y = -5357, z = 52 },	-- Eastern edge
			},
		},
		{
			name = "Mos Espa",
			hotspots = {
				{ x = -2809, y = 2129, z = 5 },	-- Starport
				{ x = -2969, y = 2322, z = 5 },	-- Bank
				{ x = -2991, y = 2124, z = 5 },	-- Cantina
				{ x = -3150, y = 2125, z = 5 },	-- Medical Center
				{ x = -2793, y = 2179, z = 5 },	-- Shuttleport A
				{ x = -2886, y = 1930, z = 5 },	-- Shuttleport B (south)
				{ x = -3114, y = 2166, z = 5 },	-- Shuttleport C
				{ x = -3093, y = 2271, z = 5 },	-- Cloning
			},
		},
		{
			name = "Wayfar",
			hotspots = {
				{ x = -5174, y = -6582, z = 75 },	-- City center
				{ x = -5150, y = -6588, z = 75 },	-- Cantina area
				{ x = -5273, y = -6549, z = 75 },	-- Western side
				{ x = -5123, y = -6616, z = 75 },	-- Medical / south
				{ x = -5050, y = -6627, z = 75 },	-- Eastern edge
			},
		},
	},

	-- Wave definitions
	-- Wave 1 is the big push; later waves have fewer but tougher Tuskens
	waves = {
		-- Wave 1: mass of raiders + warriors/snipers
		{
			minCount = 50,
			maxCount = 70,
			templates = {
				"tusken_raider",
				"tusken_raider",
				"tusken_raider",
				"tusken_raider",
				"tusken_warrior",
				"tusken_warrior",
				"tusken_sniper",
			},
		},

		-- Wave 2: mid-tier pressure (fewer, meaner)
		{
			minCount = 35,
			maxCount = 50,
			templates = {
				"tusken_warrior",
				"tusken_warrior",
				"tusken_sniper",
				"tusken_sniper",
				"tusken_captain",
				"tusken_captain",
				"tusken_berserker",
				"tusken_berserker",
			},
		},

		-- Wave 3 (final): elite / champion push
		{
			minCount = 20,
			maxCount = 30,
			templates = {
				"tusken_captain",
				"tusken_elite_guard",
				"tusken_berserker",
				"tusken_blood_champion",
				"tusken_carnage_champion",
				"tusken_raid_champion",
				"tusken_war_master",
			},
		},
	},
}

registerScreenPlay("TuskenCityRaid", true)

function TuskenCityRaid:start()
	if (not isZoneEnabled("tatooine")) then
		return
	end

	-- First raid after a short delay so the server finishes loading
	local firstDelay = getRandomNumber(5 * 60, 12 * 60) * 1000
	createEvent(firstDelay, "TuskenCityRaid", "scheduleNextRaid", nil, "")
end

function TuskenCityRaid:scheduleNextRaid()
	local delay = getRandomNumber(self.config.minInterval, self.config.maxInterval) * 1000
	createEvent(delay, "TuskenCityRaid", "startRaid", nil, "")
end

function TuskenCityRaid:startRaid()
	local city = self.cities[getRandomNumber(1, #self.cities)]

	if (self.config.announce) then
		print("[TuskenCityRaid] Tusken Raiders are advancing on " .. city.name .. "!")
	end

	-- Store which city is under attack + raid state
	writeSharedMemory("TuskenCityRaid:cityName", city.name)
	writeSharedMemory("TuskenCityRaid:currentWave", "1")
	writeSharedMemory("TuskenCityRaid:active", "1")

	-- Keep a reference to the full city table (hotspots) via index so spawnWave can find it
	-- We store the city name and look it up later
	self.currentCity = city

	-- Spawn first wave across the city's hotspots
	self:spawnWave(1)

	-- Start the kill-progress checker
	createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")

	-- Safety cleanup after max duration
	createEvent(self.config.raidDuration * 1000, "TuskenCityRaid", "cleanupRaid", nil, "")

	-- Schedule the next full raid
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
		-- Fallback (should not happen)
		if (self.config.announce) then
			print("[TuskenCityRaid] ERROR: could not find city data for " .. tostring(cityName))
		end
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

			local x = hotspot.x + offsetX
			local y = hotspot.y + offsetY
			local z = hotspot.z

			local pMobile = spawnMobile("tatooine", template, 0, x, z, y, getRandomNumber(0, 360), 0)

			if (pMobile ~= nil) then
				CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)
				table.insert(spawnedOids, SceneObject(pMobile):getObjectID())
			end
		end
	end

	writeSharedMemory("TuskenCityRaid:currentOids", table.concat(spawnedOids, ","))
	writeSharedMemory("TuskenCityRaid:currentWave", tostring(waveNumber))

	if (self.config.announce) then
		print("[TuskenCityRaid] Wave " .. waveNumber .. " spawned across " .. city.name .. " (" .. #spawnedOids .. " Tuskens at " .. numHotspots .. " hotspots)")
	end
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
			local cityName = readSharedMemory("TuskenCityRaid:cityName") or "the city"
			print("[TuskenCityRaid] All waves defeated at " .. cityName .. "!")
		end

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
