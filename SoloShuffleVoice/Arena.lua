local addonName, addon = ...

-- Force baseline variables to update instantly across the entire folder namespace
addon.InArena = false
addon.IsSoloShuffle = false

-- Global Override: Force debug visibility directly on command loop evaluation
if not addon.InArena then
    local _, instanceType = GetInstanceInfo()
    if instanceType == "arena" then
        addon.InArena = true
        addon.IsSoloShuffle = true
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PVP_MATCH_ACTIVE")
frame:RegisterEvent("ARENA_ROUND_START")

local function ForceStateUpdate()
    local name, instanceType = GetInstanceInfo()
    
    if instanceType == "arena" then
        addon.InArena = true
        addon.IsSoloShuffle = true
    else
        addon.InArena = false
        addon.IsSoloShuffle = false
    end
    
    return addon.InArena
end

frame:SetScript("OnEvent", function(self, event, ...)
    -- Forcefully assign variables the millisecond any world map event fires
    ForceStateUpdate()

    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        if addon.InArena then
            -- Use the exact short log tag shown on your screen capture
            print("|cff00ffcc[SoloVoice]|r Match verified. Displaying Control Panel.")
            if addon.MainFrame then addon.MainFrame:Show() end
        else
            if addon.MainFrame then addon.MainFrame:Hide() end
            addon.voiceChannelFromGroup = nil
            addon.voiceChannelName = nil
            addon.voiceChannelID = nil
        end

    elseif event == "PVP_MATCH_ACTIVE" or event == "ARENA_ROUND_START" then
        if addon.InArena then
            print("|cff00ffcc[SoloVoice]|r New match round detected! Flushing connection cache...")
            addon.voiceChannelFromGroup = nil
            if addon.SendReady then
                C_Timer.After(1, function() addon.SendReady() end)
            end
            if addon.UpdateVoiceUI then addon.UpdateVoiceUI() end
        end
    end
end)

-- Execute a baseline check immediately when the file loads into game memory
ForceStateUpdate()

