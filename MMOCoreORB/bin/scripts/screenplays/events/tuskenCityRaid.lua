TuskenCityRaid = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TuskenCityRaid",

	-- ======================
	-- CONFIGURATION
	-- ======================
	config = {
		-- Time between raids (in seconds)
		minInterval = 45 * 60,		-- 45 minutes
		maxInterval = 90 * 60,		-- 90 minutes

		-- How long the raid lasts before remaining Tuskens are despawned
		raidDuration = 20 * 60,		-- 20 minutes

		-- Number of Tuskens to spawn per raid
		minRaiders = 8,
		maxRaiders = 16,

		-- How far from the city center the Tuskens can spawn (in meters)
		spawnRadius = 80,

		-- Whether to print a server log message when a raid starts
		announce = true,
	},

	-- Cities that can be raided (Tatooine only for now)
	-- Format: { name = "Display Name", x = cityCenterX, y = cityCenterY, z = height }
	cities = {
		{ name = "Bestine",       x = -1200, y = -3600, z = 12 },
		{ name = "Mos Eisley",    x =  3400, y = -4800, z =  5 },
		{ name = "Anchorhead",   x =    80, y = -5350, z = 52 },
		{ name = "Mos Espa",     x = -2900, y =  2200, z =  5 },
		{ name = "Wayfar",       x = -5100, y = -6500, z = 75 },
	},

	-- Tusken templates that can spawn (weighted toward common ones)
	tuskenTemplates = {
		"tusken_raider",
		"tusken_raider",
		"tusken_raider",
		"tusken_warrior",
		"tusken_warrior",
		"tusken_sniper",
		"tusken_captain",
	},
}

registerScreenPlay("TuskenCityRaid", true)

function TuskenCityRaid:start()
	if (not isZoneEnabled("tatooine")) then
		return
	end

	-- Start the first raid after a short random delay so the server can fully load
	local firstDelay = getRandomNumber(5 * 60, 15 * 60) * 1000		-- 5-15 minutes
	createEvent(firstDelay, "TuskenCityRaid", "scheduleNextRaid", nil, "")
end

function TuskenCityRaid:scheduleNextRaid()
	local delay = getRandomNumber(self.config.minInterval, self.config.maxInterval) * 1000
	createEvent(delay, "TuskenCityRaid", "startRaid", nil, "")
end

function TuskenCityRaid:startRaid()
	-- Pick a random city
	local city = self.cities[getRandomNumber(1, #self.cities)]

	local numRaiders = getRandomNumber(self.config.minRaiders, self.config.maxRaiders)

	if (self.config.announce) then
		print("[TuskenCityRaid] A large group of Tusken Raiders is advancing on " .. city.name .. "!")
		-- Optional: Add a planetary broadcast here if you have a preferred method
		-- e.g. using ChatManager or looping online players on Tatooine
	end

	local spawnedOids = {}

	for i = 1, numRaiders do
		local template = self.tuskenTemplates[getRandomNumber(1, #self.tuskenTemplates)]

		-- Random offset around the city center
		local offsetX = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)
		local offsetY = getRandomNumber(-self.config.spawnRadius, self.config.spawnRadius)

		local x = city.x + offsetX
		local y = city.y + offsetY
		local z = city.z

		local pMobile = spawnMobile("tatooine", template, 0, x, z, y, getRandomNumber(0, 360), 0)

		if (pMobile ~= nil) then
			-- Ensure they are aggressive toward players
			CreatureObject(pMobile):setPvpStatusBitmask(AGGRESSIVE + ATTACKABLE + ENEMY)

			table.insert(spawnedOids, SceneObject(pMobile):getObjectID())
		end
	end

	-- Store the list so we can clean them up later
	writeSharedMemory("TuskenCityRaid:currentOids", table.concat(spawnedOids, ","))
	writeSharedMemory("TuskenCityRaid:cityName", city.name)

	-- Schedule cleanup
	createEvent(self.config.raidDuration * 1000, "TuskenCityRaid", "cleanupRaid", nil, "")

	-- Schedule the next raid
	self:scheduleNextRaid()
end

function TuskenCityRaid:cleanupRaid()
	local oidString = readSharedMemory("TuskenCityRaid:currentOids")
	local cityName = readSharedMemory("TuskenCityRaid:cityName") or "a city"

	if (oidString == nil or oidString == "") then
		return
	end

	local oids = {}
	for oid in string.gmatch(oidString, "([^,]+)") do
		table.insert(oids, tonumber(oid))
	end

	local remaining = 0

	for _, oid in ipairs(oids) do
		local pObj = getSceneObject(oid)
		if (pObj ~= nil and SceneObject(pObj):isCreatureObject()) then
			if (not CreatureObject(pObj):isDead()) then
				SceneObject(pObj):destroyObjectFromWorld()
				remaining = remaining + 1
			end
		end
	end

	-- Clear the memory
	deleteSharedMemory("TuskenCityRaid:currentOids")
	deleteSharedMemory("TuskenCityRaid:cityName")

	if (self.config.announce and remaining > 0) then
		print("[TuskenCityRaid] The Tusken raid on " .. cityName .. " has ended. " .. remaining .. " raiders remaining were despawned.")
	end
end
