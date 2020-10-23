-- IMPORT @ DEFAULT
-- PRIORITY 150

--[[ Installation Instructions:
	Place this file in /Content/Mods/BonusDarknessLevels/Scripts
	Add 'Import "../Mods/DarknessForHeat/Scripts/DarknessForHeat.lua"' to the bottom of RoomManager.lua
	Configure by changing values in the config table below
	Load/reload a save
--]]

--[[
Mod: DarknessForHeat
Author: Mike Riley(TurboCop)
        A mod that lets zagreus have temporary bonus levels from the mirror of darkness, but only for that run.
-]]

--[[
    Github location: 
]]
ModUtil.RegisterMod("MoreDarknessForHeat")


local config = --  
{
    Enabled = true, -- Easy access to turn on and off this mod
}

MoreDarknessForHeat.config = config

if MoreDarknessForHeat.config.Enabled then
    ModUtil.BaseOverride("CalculateMetaPointMultiplier", function() 
        local totalMetaPointMultiplier = 1.0
        for key, upgradeName in pairs( CurrentRun.EnemyUpgrades ) do
            local upgradeData = EnemyUpgradeData[upgradeName]
            if upgradeData.MetaPointMultiplier then
                totalMetaPointMultiplier = totalMetaPointMultiplier + (upgradeData.MetaPointMultiplier - 1)
            end
        end
        local currentHeat = GetTotalSpentShrinePoints()
        local currentHeatPercentage = 0.05 * currentHeat
        --- Add 5 percent extra per heat
        totalMetaPointMultiplier = totalMetaPointMultiplier + currentHeatPercentage
        local displayHeatPercent = currentHeatPercentage * 100
        ModUtil.Hades.PrintOverhead("+" .. displayHeatPercent .. "% Darkness!")
        local finalMPM = totalMetaPointMultiplier * GetTotalHeroTraitValue("MetaPointMultiplier", {IsMultiplier = true})
        return finalMPM
    end, DarknessForHeat)
end