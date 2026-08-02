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
		raidDuration = 45 * 60,		-- 45 minutes safety net

		-- Random offset radius around each hotspot (meters)
		hotspotRadius = 35,

		-- How often (seconds) to check wave progress per city
		waveCheckInterval = 15,

		-- A city's wave is considered complete when this many or fewer remain alive in that city
		waveCompleteThreshold = 3,

		-- Print server log messages
		announce = true,
	},

	-- All major Corellia cities with multiple high-traffic hotspots
	-- spawnMultiplier lets us scale individual cities (Bela Vistal is smaller)
	cities = {
		{
			name = "Coronet",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -131,  y = -4723, z = 28 },	-- Starport
				{ x = -60,   y = -4599, z = 28 },	-- Bank
				{ x = -346,  y = -4542, z = 28 },	-- Cantina
				{ x = -106,  y = -4461, z = 28 },	-- Medical Center
				{ x = -23,   y = -4401, z = 28 },	-- Northern Shuttleport / entrance
				{ x = -209,  y = -4534, z = 28 },	-- Capital / downtown
				{ x = -329,  y = -4636, z = 28 },	-- Southern Shuttle area
				{ x = -480,  y = -4499, z = 28 },	-- Cloning / western edge
			},
		},
		{
			name = "Tyrena",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -5031, y = -2287, z = 21 },	-- Starport
				{ x = -5110, y = -2387, z = 21 },	-- Bank
				{ x = -5285, y = -2522, z = 21 },	-- Cantina
				{ x = -5005, y = -2476, z = 21 },	-- Medical Center
				{ x = -5005, y = -2381, z = 21 },	-- Eastern Shuttleport
				{ x = -5603, y = -2790, z = 21 },	-- Western Shuttleport
				{ x = -5201, y = -2566, z = 21 },	-- Central plaza / hotel area
			},
		},
		{
			name = "Bela Vistal",
			spawnMultiplier = 0.5,		-- Smaller city - half the numbers
			hotspots = {
				{ x = 6800,  y = -5700, z = 315 },	-- City center
				{ x = 6735,  y = -5708, z = 315 },	-- Cantina
				{ x = 6909,  y = -5581, z = 315 },	-- Medical / northern
				{ x = 6637,  y = -5921, z = 315 },	-- Southern shuttle / entrance
				{ x = 6937,  y = -5536, z = 315 },	-- Northern edge
				{ x = 6853,  y = -5443, z = 315 },	-- Guild / upper area
			},
		},
		{
			name = "Doaba Guerfel",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = 3340,  y = 5534, z = 300 },	-- Starport
				{ x = 3207,  y = 5382, z = 300 },	-- Bank
				{ x = 3268,  y = 5373, z = 300 },	-- Cantina
				{ x = 3262,  y = 5422, z = 300 },	-- Medical Center
				{ x = 3078,  y = 4995, z = 300 },	-- Southern shuttle / entrance
				{ x = 3108,  y = 5205, z = 300 },	-- Hotel area
			},
		},
		{
			name = "Kor Vella",
			spawnMultiplier = 1.0,
			hotspots = {
				{ x = -3138, y = 2815, z = 86 },	-- Starport
				{ x = -3464, y = 3039, z = 86 },	-- Cantina
				{ x = -3793, y = 3157, z = 86 },	-- Medical Center
				{ x = -3126, y = 2790, z = 86 },	-- Bank / garage area
				{ x = -3777, y = 3240, z = 86 },	-- Shuttleport
				{ x = -3268, y = 3109, z = 86 },	-- Hotel / central
				{ x = -3434, y = 3197, z = 86 },	-- Guild area
			},
		},
	},

	-- Wave definitions - base numbers (applied after city multiplier)
	waves = {
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_fool",
				"meatlump_fool",
				"meatlump_buffoon",
				"meatlump_stooge",
				"meatlump_oaf",
				"meatlump_clod",
			},
		},
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_clod",
				"meatlump_clod",
				"meatlump_cretin",
				"meatlump_loon",
				"meatlump_stooge",
				"meatlump_oaf",
			},
		},
		{
			minCount = 80,
			maxCount = 100,
			templates = {
				"meatlump_clod",
				"meatlump_cretin",
				"meatlump_loon",
				"meatlump_loon",
				"meatlump_oaf",
				"meatlump_stooge",
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
	createEvent(delay, "MeatlumpCityRaid", "issueWarning", nil, "")
end

function MeatlumpCityRaid:issueWarning()
	local warningMsg = "Rumors are spreading across Corellia... the Meatlumps are stirring. Whispers of coordinated mischief and sudden raids on city streets have begun to circulate. Citizens are advised to stay alert."
	broadcastToGalaxy(warningMsg)

	if (self.config.announce) then
		print("[MeatlumpCityRaid] 30-minute warning issued: Meatlumps preparing to strike all Corellia cities.")
	end

	createEvent(self.config.warningLeadTime * 1000, "MeatlumpCityRaid", "startRaid", nil, "")
end

function MeatlumpCityRaid:startRaid()
	if (self.config.announce) then
		print("[MeatlumpCityRaid] Meatlumps are raiding all Corellia cities!")
	end

	local startMsg = "The Meatlumps have made their move! Chaotic bands of the infamous street gang have poured into the streets of every major city on Corellia. Defend the towns!"
	broadcastToGalaxy(startMsg)

	writeSharedMemory("MeatlumpCityRaid:active", "1")

	-- Initialize and spawn Wave 1 independently for every city
	for _, city in ipairs(self.cities) do
		writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave", "1")
		writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done", "0")
		self:spawnWaveForCity(city, 1)
	end

	-- Start the per-city progress checker
	createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkAllCitiesProgress", nil, "")

	-- Safety cleanup after max duration
	createEvent(self.config.raidDuration * 1000, "MeatlumpCityRaid", "cleanupRaid", nil, "")

	-- Schedule the next full raid cycle
	self:scheduleNextRaid()
end

function MeatlumpCityRaid:spawnWaveForCity(city, waveNumber)
	local waveDef = self.waves[waveNumber]
	if (waveDef == nil) then
		return
	end

	local multiplier = city.spawnMultiplier or 1.0
	local totalForCity = math.floor(getRandomNumber(waveDef.minCount, waveDef.maxCount) * multiplier)
	-- Ensure at least a few even with multiplier
	if (totalForCity < 5) then
		totalForCity = 5
	end

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

			local x = hotspot.x + offsetX
			local y = hotspot.y + offsetY
			local z = hotspot.z

			local pMobile = spawnMobile("corellia", template, 0, x, z, y, getRandomNumber(0, 360), 0)

			if (pMobile ~= nil) then
				CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)
				table.insert(cityOids, SceneObject(pMobile):getObjectID())
			end
		end
	end

	writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids", table.concat(cityOids, ","))
	writeSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave", tostring(waveNumber))

	if (self.config.announce) then
		print("[MeatlumpCityRaid] Wave " .. waveNumber .. " spawned in " .. city.name .. " (" .. #cityOids .. " Meatlumps)")
	end
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
		-- Keep checking while at least one city still has waves left
		createEvent(self.config.waveCheckInterval * 1000, "MeatlumpCityRaid", "checkAllCitiesProgress", nil, "")
	else
		-- Every city has finished all waves
		if (self.config.announce) then
			print("[MeatlumpCityRaid] All cities have cleared every wave!")
		end

		local endMsg = "The Meatlump assault has been driven back. The streets of Corellia's cities grow quieter once more... for now."
		broadcastToGalaxy(endMsg)

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
		-- This city is ready for its next wave
		self:spawnWaveForCity(city, nextWave)
	else
		-- This city has finished all waves
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
			end
		end

		-- Clear all per-city state
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":oids")
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":wave")
		deleteSharedMemory("MeatlumpCityRaid:" .. city.name .. ":done")
	end

	if (self.config.announce and totalRemaining > 0) then
		print("[MeatlumpCityRaid] Raid ended. " .. totalRemaining .. " remaining Meatlumps despawned.")
	end

	deleteSharedMemory("MeatlumpCityRaid:active")
end
