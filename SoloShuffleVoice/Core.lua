local addonName, addon = ...

-- Core event handler frame
local coreFrame = CreateFrame("Frame")
coreFrame:RegisterEvent("PLAYER_LOGIN")

coreFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if addon.Utils then
            addon.Utils:Log("Addon initialized! Type /ssv to toggle the interface.")
        else
            print("|cff00ffcc[SoloShuffleVoice]|r Loaded successfully!")
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

-- Slash Command Handler Setup
SLASH_SSV1 = "/ssv"

SlashCmdList["SSV"] = function(msg)
    -- Clean up input string
    msg = string.lower(string.trim(msg or ""))

    if msg == "debug" then
        if addon.Utils then addon.Utils:Log("=== Solo Shuffle Voice Debug ===") end
        
        local zoneName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
        print("   Zone Name:   ", zoneName or "Unknown")
        print("   Instance Type:", instanceType or "None")
        print("   Instance ID:  ", instanceID or "N/A")
        print("   In Arena Check:", tostring(addon.InArena))
        print("   Is Shuffle:   ", tostring(addon.IsSoloShuffle))

        -- Trigger the Voice engine's specific report
        if addon.DebugVoice then
            addon.DebugVoice()
        end

    elseif msg == "ready" then
        if addon.SendReady then
            addon.SendReady()
            if addon.Utils then addon.Utils:Log("Sent network handshake to team.") end
        else
            if addon.Utils then addon.Utils:Log("Error: Network module is missing.") end
        end

    elseif msg == "list" then
        if addon.Utils then addon.Utils:Log("Compatible active teammates:") end
        
        local count = 0
        if addon.players then
            for player in pairs(addon.players) do
                print(" - " .. tostring(player))
                count = count + 1
            end
        end
        print(" Total teammates with addon: " .. tostring(count))

    else
        -- Default behavior: Toggle the main UI panel visibility
        if addon.MainFrame then
            if addon.MainFrame:IsShown() then
                addon.MainFrame:Hide()
            else
                addon.MainFrame:Show()
                -- Refresh UI data upon opening
                if addon.UpdateVoiceUI then addon.UpdateVoiceUI() end
            end
        else
            if addon.Utils then addon.Utils:Log("Error: UI module is missing.") end
        end
    end
end

