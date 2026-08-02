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
		raidDuration = 45 * 60,		-- 45 minutes safety net (bigger event needs more time)

		-- Random offset radius around each hotspot (meters)
		hotspotRadius = 35,

		-- How often (seconds) to check if the current wave is mostly dead
		waveCheckInterval = 20,

		-- Wave is considered complete when this many or fewer remain alive across ALL cities
		waveCompleteThreshold = 8,

		-- Print server log messages
		announce = true,
	},

	-- All major Corellia cities with multiple high-traffic hotspots
	-- Spawns are distributed across these points so the city feels under attack from multiple directions
	cities = {
		{
			name = "Coronet",
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

	-- Wave definitions - consistent BIG numbers for every wave
	waves = {
		-- Wave 1
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

		-- Wave 2
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

		-- Wave 3 (final)
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

	-- First raid after a longer delay so the server settles
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

	writeSharedMemory("MeatlumpCityRaid:currentWave", "1")
	writeSharedMemory("MeatlumpCityRaid:active", "1")

	-- Spawn first wave in EVERY city across multiple hotspots
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
		local totalForCity = getRandomNumber(waveDef.minCount, waveDef.maxCount)
		local hotspots = city.hotspots
		local numHotspots = #hotspots

		-- Distribute the total roughly evenly across hotspots (with leftover going to random ones)
		local basePerHotspot = math.floor(totalForCity / numHotspots)
		local remainder = totalForCity % numHotspots

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
					table.insert(allOids, SceneObject(pMobile):getObjectID())
				end
			end
		end

		if (self.config.announce) then
			print("[MeatlumpCityRaid] Wave " .. waveNumber .. " spawned across " .. city.name .. " (" .. totalForCity .. " Meatlumps at " .. numHotspots .. " hotspots)")
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
