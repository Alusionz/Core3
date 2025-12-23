includeFile("object/tangible/tangible_base.lua")  -- Base for all tangibles

resource_crate = {
    objectMenuComponent = "ResourceCrateMenuComponent",
    objectName = "@veteran_new:resource_crate",  -- Reuse a string or add custom
    customName = "Free Resource Crate",
    gameObjectType = 8211,  -- Deed type (same as structure deeds)
    clientObjectCRC = 1234567890,  -- Placeholder; will auto-generate or set properly
    appearanceFilename = "appearance/itm_deed.apt",
    useCount = 1  -- Single-use; optional, but good for balance
}

-- Attach the component
require("object.tangible.custom.resource_crate_menu_component")