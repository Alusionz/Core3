MeatlumpCityRaid = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MeatlumpCityRaid",

	-- ======================
	-- CONFIGURATION
	-- ======================
	config = {
		-- Time between full raids (in seconds) - much rarer than Tusken
		minInterval = 3 * 60 * 60,		-- 3 hours
		maxInterval = 6 * 60 * 60,		-- 6 hours

		-- Warning lead time before the actual raid starts
		warningLeadTime = 30 * 60,		-- 30 minutes

		-- Maximum total duration of a raid before remaining Meatlumps are force-despawned
		raidDuration = 30 * 60,		-- 30 minutes safety net

		-- How far from the city center the Meatlumps can spawn (in meters)
		spawnRadius = 70,

		-- How often (seconds) to check if the current wave is mostly dead
		waveCheckInterval = 15,

		-- Wave is considered complete when this many or fewer remain alive
		waveCompleteThreshold = 2,

		-- Print server log messages
		announce = true,
	},

	-- All major Corellia cities (raid hits every one)
	cities = {
		{ name = "Coronet",       x =  -180, y = -4700, z = 28 },
		{ name = "Tyrena",        x = -5200, y = -2500, z = 21 },
		{ name = "Bela Vistal",   x =  6800, y = -5700, z = 315 },
		{ name = "Doaba Guerfel", x =  3300, y =  5400, z = 300 },
		{ name = "Kor Vella",     x = -3400, y =  3100, z = 86 },
	},

	-- Wave definitions using available Meatlump templates
	waves = {
		-- Wave 1: street-level rabble
		{
			minCount = 6,
			maxCount = 10,
			templates = {
				"meatlump_fool",
				"meatlump_fool",
				"meatlump_buffoon",
				"meatlump_stooge",
				"meatlump_oaf",
			},
		},

		-- Wave 2: denser, slightly meaner bunch
		{
			minCount = 5,
			maxCount = 9,
			templates = {
				"meatlump_clod",
				"meatlump_clod",
				"meatlump_cretin",
				"meatlump_loon",
				"meatlump_stooge",
				"meatlump_oaf",
			},
		},

		-- Wave 3: final chaotic push
		{
			minCount = 4,
			maxCount = 7,
			templates = {
				"meatlump_clod",
				"meatlump_cretin",
				"meatlump_loon",
				"meatlump_loon",
				"meatlump_oaf",
			},
		},
	},
}

registerScreenPlay("MeatlumpCityRaid", true)

function MeatlumpCityRaid:start()
	if (not isZoneEnabled("corellia")) then
		return
	end

	-- First raid after a longer delay so the server settles
	local firstDelay = getRandomNumber(20 * 60, 45 * 60) * 1000
	createEvent(firstDelay, "MeatlumpCityRaid", "scheduleNextRaid", nil, "")
end

function MeatlumpCityRaid:scheduleNextRaid()
	local delay = getRandomNumber(self.config.minInterval, self.config.maxInterval) * 1000
	createEvent(delay, "MeatlumpCityRaid", "issueWarning", nil, "")
end

function MeatlumpCityRaid:issueWarning()
	-- 30-minute lore-flavored warning to players on Corellia (via galaxy broadcast with clear planet context)
	local warningMsg = "Rumors are spreading across Corellia... the Meatlumps are stirring. Whispers of coordinated mischief and sudden raids on city streets have begun to circulate. Citizens are advised to stay alert."

	broadcastToGalaxy(warningMsg)

	if (self.config.announce) then
		print("[MeatlumpCityRaid] 30-minute warning issued: Meatlumps preparing to strike all Corellia cities.")
	end

	-- Actual raid starts after the warning lead time
	createEvent(self.config.warningLeadTime * 1000, "MeatlumpCityRaid", "startRaid", nil, "")
end

function MeatlumpCityRaid:startRaid()
	if (self.config.announce) then
		print("[MeatlumpCityRaid] Meatlumps are raiding all Corellia cities!")
	end

	local startMsg = "The Meatlumps have made their move! Chaotic bands of the infamous street gang have poured into the streets of every major city on Corellia. Defend the towns!"
	broadcastToGalaxy(startMsg)

	writeSharedMemory("MeatlumpCityRaid:currentWave", "1")
	writeSharedMemory("MeatlumpCityRaid:active", "1")

	-- Spawn first wave in EVERY city
	self:spawnWaveAcrossAllCities(1)

	-- Start the kill-progress checker
	createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkWaveProgress", nil, "")

	-- Safety cleanup after max duration
	createEvent(self.config.raidDuration * 1000, "MeatlumpCityRaid", "cleanupRaid", nil, "")

	-- Schedule the next full raid cycle
	self:scheduleNextRaid()
end

function MeatlumpCityRaid:spawnWaveAcrossAllCities(waveNumber)
	local waveDef = self.waves[waveNumber]
	if (waveDef == nil) then
		return
	end

	local allOids = {}

	for _, city in ipairs(self.cities) do
		local count = getRandomNumber(waveDef.minCount, waveDef.maxCount)

		for i = 1, count do
			local template = waveDef.templates[getRandomNumber(1, #waveDef.templates)]

			local offsetX = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)
			local offsetY = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)

			local x = city.x + offsetX
			local y = city.y + offsetY
			local z = city.z

			local pMobile = spawnMobile("corellia", template, 0, x, z, y, getRandomNumber(0, 360), 0)

			if (pMobile ~= nil) then
				CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)
				table.insert(allOids, SceneObject(pMobile):getObjectID())
			end
		end

		if (self.config.announce) then
			print("[MeatlumpCityRaid] Wave " .. waveNumber .. " spawned near " .. city.name .. " (" .. count .. " Meatlumps)")
		end
	end

	writeSharedMemory("MeatlumpCityRaid:currentOids", table.concat(allOids, ","))
	writeSharedMemory("MeatlumpCityRaid:currentWave", tostring(waveNumber))
end

function MeatlumpCityRaid:checkWaveProgress()
	if (readSharedMemory("MeatlumpCityRaid:active") ~= "1") then
		return
	end

	local oidString = readSharedMemory("MeatlumpCityRaid:currentOids")
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
		createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkWaveProgress", nil, "")
	end
end

function MeatlumpCityRaid:advanceOrFinish()
	local currentWave = tonumber(readSharedMemory("MeatlumpCityRaid:currentWave")) or 1
	local nextWave = currentWave + 1

	if (self.waves[nextWave] ~= nil) then
		self:spawnWaveAcrossAllCities(nextWave)
		createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkWaveProgress", nil, "")
	else
		if (self.config.announce) then
			print("[MeatlumpCityRaid] All waves defeated across Corellia!")
		end

		local endMsg = "The Meatlump assault has been driven back. The streets of Corellia's cities grow quieter once more... for now."
		broadcastToGalaxy(endMsg)

		self:cleanupRaid()
	end
end

function MeatlumpCityRaid:cleanupRaid()
	writeSharedMemory("MeatlumpCityRaid:active", "0")

	local oidString = readSharedMemory("MeatlumpCityRaid:currentOids")

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
			print("[MeatlumpCityRaid] Raid ended. " .. remaining .. " remaining Meatlumps despawned.")
		end
	end

	deleteSharedMemory("MeatlumpCityRaid:currentOids")
	deleteSharedMemory("MeatlumpCityRaid:currentWave")
	deleteSharedMemory("MeatlumpCityRaid:active")
end
