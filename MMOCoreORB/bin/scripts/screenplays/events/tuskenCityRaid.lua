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
		raidDuration = 25 * 60,		-- 25 minutes safety net

		-- How far from the city center the Tuskens can spawn (in meters)
		spawnRadius = 90,

		-- How often (seconds) to check if the current wave is mostly dead
		waveCheckInterval = 12,

		-- Wave is considered complete when this many or fewer remain alive
		-- (set to 0 if you want the next wave only after every last one is dead)
		waveCompleteThreshold = 1,

		-- Print server log messages
		announce = true,
	},

	-- Cities that can be raided
	cities = {
		{ name = "Bestine",     x = -1200, y = -3600, z = 12 },
		{ name = "Mos Eisley",  x =  3400, y = -4800, z =  5 },
		{ name = "Anchorhead", x =    80, y = -5350, z = 52 },
		{ name = "Mos Espa",   x = -2900, y =  2200, z =  5 },
		{ name = "Wayfar",     x = -5100, y = -6500, z = 75 },
	},

	-- Wave definitions
	-- Each wave has its own template list and size range
	waves = {
		-- Wave 1: basic + a few warriors/snipers
		{
			minCount = 8,
			maxCount = 12,
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

		-- Wave 2: mid-tier pressure
		{
			minCount = 6,
			maxCount = 10,
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
			minCount = 4,
			maxCount = 7,
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

	-- Store raid context
	writeSharedMemory("TuskenCityRaid:cityName", city.name)
	writeSharedMemory("TuskenCityRaid:cityX", tostring(city.x))
	writeSharedMemory("TuskenCityRaid:cityY", tostring(city.y))
	writeSharedMemory("TuskenCityRaid:cityZ", tostring(city.z))
	writeSharedMemory("TuskenCityRaid:currentWave", "1")
	writeSharedMemory("TuskenCityRaid:active", "1")

	-- Spawn first wave
	self:spawnWave(1)

	-- Start the kill-progress checker
	createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")

	-- Safety cleanup after max duration
	createEvent(self.config.raidDuration * 1000, "TuskenCityRaid", "cleanupRaid", nil, "")

	-- Schedule the next full raid
	self:scheduleNextRaid()
end

function TuskenCityRaid:spawnWave(waveNumber)
	local waveDef = self.waves[waveNumber]
	if (waveDef == nil) then
		return
	end

	local cityX = tonumber(readSharedMemory("TuskenCityRaid:cityX"))
	local cityY = tonumber(readSharedMemory("TuskenCityRaid:cityY"))
	local cityZ = tonumber(readSharedMemory("TuskenCityRaid:cityZ"))
	local cityName = readSharedMemory("TuskenCityRaid:cityName") or "a city"

	local count = getRandomNumber(waveDef.minCount, waveDef.maxCount)
	local spawnedOids = {}

	for i = 1, count do
		local template = waveDef.templates[getRandomNumber(1, #waveDef.templates)]

		local offsetX = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)
		local offsetY = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)

		local x = cityX + offsetX
		local y = cityY + offsetY
		local z = cityZ

		local pMobile = spawnMobile("tatooine", template, 0, x, z, y, getRandomNumber(0, 360), 0)

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)
			table.insert(spawnedOids, SceneObject(pMobile):getObjectID())
		end
	end

	writeSharedMemory("TuskenCityRaid:currentOids", table.concat(spawnedOids, ","))
	writeSharedMemory("TuskenCityRaid:currentWave", tostring(waveNumber))

	if (self.config.announce) then
		print("[TuskenCityRaid] Wave " .. waveNumber .. " spawned near " .. cityName .. " (" .. #spawnedOids .. " Tuskens)")
	end
end

function TuskenCityRaid:checkWaveProgress()
	-- Stop checking if the raid is no longer active
	if (readSharedMemory("TuskenCityRaid:active") ~= "1") then
		return
	end

	local oidString = readSharedMemory("TuskenCityRaid:currentOids")
	if (oidString == nil or oidString == "") then
		-- Nothing left to track, try next wave or finish
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

	-- If few enough remain, advance to next wave (or finish)
	if (alive <= self.config.waveCompleteThreshold) then
		self:advanceOrFinish()
	else
		-- Keep checking
		createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")
	end
end

function TuskenCityRaid:advanceOrFinish()
	local currentWave = tonumber(readSharedMemory("TuskenCityRaid:currentWave")) or 1
	local nextWave = currentWave + 1

	if (self.waves[nextWave] ~= nil) then
		-- Spawn the next wave
		self:spawnWave(nextWave)

		-- Resume checking
		createEvent(self.config.waveCheckInterval * 1000, "TuskenCityRaid", "checkWaveProgress", nil, "")
	else
		-- No more waves – raid complete
		if (self.config.announce) then
			local cityName = readSharedMemory("TuskenCityRaid:cityName") or "the city"
			print("[TuskenCityRaid] All waves defeated at " .. cityName .. "!")
		end

		-- Clean up any stragglers and mark raid inactive
		self:cleanupRaid()
	end
end

function TuskenCityRaid:cleanupRaid()
	-- Mark inactive so the checker stops
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

	-- Clear all raid data
	deleteSharedMemory("TuskenCityRaid:currentOids")
	deleteSharedMemory("TuskenCityRaid:cityName")
	deleteSharedMemory("TuskenCityRaid:cityX")
	deleteSharedMemory("TuskenCityRaid:cityY")
	deleteSharedMemory("TuskenCityRaid:cityZ")
	deleteSharedMemory("TuskenCityRaid:currentWave")
	deleteSharedMemory("TuskenCityRaid:active")
end
