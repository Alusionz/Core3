--Copyright (C) 2007 <SWGEmu>

--This File is part of Core3.

--This program is free software; you can redistribute
--it and/or modify it under the terms of the GNU Lesser
--General Public License as published by the Free Software
--Foundation; either version 2 of the License,
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

--Linking Engine3 statically or dynamically with other modules
--is making a combined work based on Engine3.
--Thus, the terms and conditions of the GNU Lesser General Public License
--cover the whole combination.

--In addition, as a special exception, the copyright holders of Engine3
--give you permission to combine Engine3 program with free software
--programs or libraries that are released under the GNU LGPL and with
--code included in the standard release of Core3 under the GNU LGPL
--license (or modified versions of such code, with unchanged license).
--You may copy and distribute such a system following the terms of the
--GNU LGPL for Engine3 and the licenses of the other code concerned,
--provided that you include the source code of that other code when
--and as the GNU LGPL requires distribution of source code.

--Note that people who make modified versions of Engine3 are not obligated
--to grant this special exception for their modified versions;
--it is their choice whether to do so. The GNU Lesser General Public License
--gives permission to release a modified version without this exception;
--this exception also makes it possible to release a modified version
--which carries forward this exception.

--Chance divisor for attribute bonus modifiers
levelChance = 10000

--Chance dividend for attribute bonus modifiers
baseChance = 10000
yellowChance = 20000
exceptionalChance = 14000
legendaryChance = 33333

--Multiplier values for bonus modifiers
baseModifier = 1
yellowModifier = 10
exceptionalModifier = 20
legendaryModifier = 25

--The chance for random skill mods to be on looted weapons/wearables
skillModChance = 3 -- skillModChance = 10 == 1 in 10

-- Dot Distribution chance by DOT type. They must equate to 1.0
poisonDotChance = 0.50
diseaseDotChance = 0.35
fireDotChance = 0.15

-- Dot Distribution chance by HAM type. They must equate to 1.0
healthDotChance = 0.50
actionDotChance = 0.35
mindDotChance = 0.15

-- Value ranges for random dots on looted weapons (chance is set individually on the loot items)
randomDotAttribute = {0, 8} -- See CreatureAttributes.h in src for numbers.
randomDotStrength = {80, 100} -- poison x1.5, disease x0.5
randomDotDuration = {300, 1200} -- disease x4.0, fire x1.5
randomDotPotency = {50, 100}
randomDotUses = {1250, 14999}

-- Modifier applied to min/max junk values found in loot item lua
junkValueModifier = 5;

-- Values used to generate lightsaber crystal stats
jediCrystalStats = {
	lightsaber_module_force_crystal = {
		minDamage = 50, --normal value is 0
		maxDamage = 150, -- normal value is 50
		minHitpoints = 700,
		maxHitpoints = 1400,
		minHealthSac = 0,
		maxHealthSac = -9,
		minActionSac = 0,
		maxActionSac = -9,
		minMindSac = 0,
		maxMindSac = -9,
		minAttackSpeed = -0.3, --normal value is 0
		maxAttackSpeed = -1.0,
		minForceCost = 0,
		maxForceCost = -9.9,
		minWoundChance = 0,
		maxWoundChance = 4,
	},
	-- Pre-P9: twin clusters use lance module template; same power stat ranges as color crystals
	lightsaber_lance_module_force_crystal = {
		minDamage = 50,
		maxDamage = 150,
		minHitpoints = 700,
		maxHitpoints = 1400,
		minHealthSac = 0,
		maxHealthSac = -9,
		minActionSac = 0,
		maxActionSac = -9,
		minMindSac = 0,
		maxMindSac = -9,
		minAttackSpeed = -0.3,
		maxAttackSpeed = -1.0,
		minForceCost = 0,
		maxForceCost = -9.9,
		minWoundChance = 0,
		maxWoundChance = 4,
	},
	lightsaber_module_krayt_dragon_pearl = {
		minDamage = 70, --normal value is 0
		maxDamage = 150, --normal value is 50
		minHitpoints = 900,
		maxHitpoints = 1400,
		minHealthSac = -6,
		maxHealthSac = -9,
		minActionSac = -6,
		maxActionSac = -9,
		minMindSac = -6,
		maxMindSac = -9,
		minAttackSpeed = -0.3,
		maxAttackSpeed = -1.0, --normal value is 0.6
		minForceCost = -5.0,
		maxForceCost = -9.9,
		minWoundChance = 2,
		maxWoundChance = 4,
	}
}
