function ResourceCrateMenuComponent:fillObjectMenuResponse(sceneObject, menuResponse, player)
    menuResponse:addRadialMenuItem(20, 3, "@veteran_new:use_resource_crate")  -- "Use" option
end

function ResourceCrateMenuComponent:handleObjectMenuSelect(sceneObject, player, selectedID)
    if (selectedID == 20) then
        -- Open SUI list of all historical resources
        local sui = SuiListBox.new("ResourceCrateMenuComponent", "handleResourceSelection")
        
        sui.setTitle("Free Resource Crate")
        sui.setPrompt("Select a resource")

        local resources = ResourceManager:getAllResourcesEverSpawned()

        for className, resList in pairs(resources) do
            sui.add(className .. " (" .. #resList .. ")", "")  -- Header (empty data = non-selectable)
            for _, resName in ipairs(resList) do
                sui.add("   " .. resName, resName)  -- Indent for readability
            end
        end

        sui.setUsingObject(sceneObject)  -- Important: passes the crate to callback
        sui.sendTo(player)
    end
    return 0
end

function ResourceCrateMenuComponent:handleResourceSelection(player, suiBox, cancelPressed, selectedIndex, args)
    if (cancelPressed or selectedIndex == -1) then
        return
    end

    local selectedResource = suiBox:getOptionText(selectedIndex)
    if (selectedResource == nil or selectedResource == "") then
        return
    end

    -- Spawn 50k units
    local pInventory = player:getSlottedObject("inventory")
    if (pInventory == nil or pInventory:isFull()) then
        player:sendSystemMessage("Your inventory is full.")
        return
    end

    -- Use Core3's built-in function to create the resource crate/stack
    createResourceCrate(player, selectedResource, 50000)

    player:sendSystemMessage("You receive 50,000 units of " .. selectedResource .. ".")

    -- Destroy the deed (single-use)
    local sceneObject = suiBox:getUsingObject()  -- Get the crate object
    if (sceneObject ~= nil) then
        sceneObject:destroyObjectFromWorld()
        sceneObject:destroyObjectFromDatabase()
    end
end