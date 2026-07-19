local addonName, addon = ...

local PREFIX = "SSVOICE"

-- Initialize data structures if they don't exist
addon.players = addon.players or {}
addon.voiceChannelFromGroup = nil

-- Helper to safely get the current chat channel type for PvP
local function GetActiveChannel()
    -- Solo Shuffle groups act as a standard party inside the instance
    return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
end

-- Broadcast to your team that you have the addon installed
function addon.SendReady()
    if not IsInGroup() then return end
    C_ChatInfo.SendAddonMessage(PREFIX, "READY", GetActiveChannel())
end

-- Broadcast your generated voice channel name to your teammates
function addon.SendVoiceChannel()
    if not addon.voiceChannelName then
        if addon.Utils then addon.Utils:Log("No voice channel created yet.") end
        return
    end

    local message = "CHANNEL:" .. addon.voiceChannelName
    C_ChatInfo.SendAddonMessage(PREFIX, message, GetActiveChannel())
    
    if addon.Utils then
        addon.Utils:Log("Sent voice channel: " .. addon.voiceChannelName)
    end
end

-- Setup the network event frame
local netFrame = CreateFrame("Frame")
netFrame:RegisterEvent("ADDON_LOADED")
netFrame:RegisterEvent("CHAT_MSG_ADDON")

netFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            -- Safely register prefix when the addon is fully operational
            C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
            self:UnregisterEvent("ADDON_LOADED")
        end
    
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        
        -- Filter out other addon traffic
        if prefix ~= PREFIX then return end

        if message == "READY" then
            addon.players[sender] = true
            
            if addon.Utils then
                addon.Utils:Log("Compatible player detected: " .. sender)
            end

            if addon.UpdatePlayerList then
                addon.UpdatePlayerList()
            end

        elseif string.sub(message, 1, 8) == "CHANNEL:" then
            local channelName = string.sub(message, 9)
            addon.voiceChannelFromGroup = channelName

            if addon.Utils then
                addon.Utils:Log(sender .. " hosted voice channel: " .. channelName)
            end
            
            -- Trigger UI or Voice system to respond to the new channel info
            if addon.OnChannelReceived then
                addon.OnChannelReceived(channelName)
            end
        end
    end
end)

