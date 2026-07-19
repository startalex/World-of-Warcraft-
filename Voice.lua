local addonName, addon = ...

addon.voiceChannelName = nil
addon.voiceChannelID = nil

-- Generates a randomized string name for the temporary voice channel
local function GenerateVoiceName()
    local randomID = math.random(10000, 99999)
    return "SSV-" .. randomID
end

-- Safely prints out all active internal channels to chat window
local function PrintChannels()
    local channels = C_VoiceChat.GetChannelList()
    if addon.Utils then addon.Utils:Log("=== Active Voice Channels ===") end

    if not channels or #channels == 0 then
        if addon.Utils then addon.Utils:Log("No active channels found on client.") end
        return
    end

    for i, channel in ipairs(channels) do
        if addon.Utils then
            addon.Utils:Log(string.format("%d) ID: %s | Name: %s", i, tostring(channel.channelID), tostring(channel.name)))
        end
    end
end

-- Primary logic path triggered by hitting the UI button
function addon.JoinVoice()
    if addon.Utils then addon.Utils:Log("Join Voice sequence initiated.") end

    -- If another player already created and broadcasted a voice channel, connect to theirs
    if addon.voiceChannelFromGroup then
        if addon.Utils then addon.Utils:Log("Found group voice link: " .. addon.voiceChannelFromGroup) end
        addon.JoinExistingVoice()
        return
    end

    -- Otherwise, prepare to host a new local room
    if not addon.voiceChannelName then
        addon.voiceChannelName = GenerateVoiceName()
    end

    if addon.Utils then addon.Utils:Log("Requesting channel creation: " .. addon.voiceChannelName) end

    -- Execute request safely through pcall wrapper
    local success, channelID = pcall(function()
        return C_VoiceChat.CreateChannel(addon.voiceChannelName)
    end)

    if success and channelID then
        addon.voiceChannelID = channelID
        if addon.Utils then addon.Utils:Log("Channel requested successfully. Awaiting engine response...") end
    else
        if addon.Utils then addon.Utils:Log("Engine error: Server rejected channel instantiation.") end
    end
end

-- Connecting path when syncing to a channel hosted by a group peer
function addon.JoinExistingVoice()
    if not addon.voiceChannelFromGroup then
        if addon.Utils then addon.Utils:Log("Error: No remote channel metadata string found.") end
        return
    end

    if addon.Utils then addon.Utils:Log("Joining remote hosted channel: " .. addon.voiceChannelFromGroup) end

    local success, channelID = pcall(function()
        return C_VoiceChat.JoinChannel(addon.voiceChannelFromGroup)
    end)

    if success and channelID then
        addon.voiceChannelID = channelID
        if addon.Utils then addon.Utils:Log("Join request sent. Awaiting voice server response...") end
    else
        if addon.Utils then addon.Utils:Log("Error: Failed to connect to group channel.") end
    end
end

-- Comprehensive visual diagnostic command tool
function addon.DebugVoice()
    if addon.Utils then
        addon.Utils:Log("=== Voice System Diagnostics ===")
        addon.Utils:Log("Local Room Target Name:  " .. tostring(addon.voiceChannelName))
        addon.Utils:Log("Registered Tracked ID:   " .. tostring(addon.voiceChannelID))
        addon.Utils:Log("Incoming Remote String:  " .. tostring(addon.voiceChannelFromGroup))
    end
    PrintChannels()
end

-- Dynamic Event Processor Frame
local voiceFrame = CreateFrame("Frame")
voiceFrame:RegisterEvent("VOICE_CHAT_CHANNEL_JOINED")

voiceFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "VOICE_CHAT_CHANNEL_JOINED" then
        local statusCode, channelID, channelType, clubId, streamId = ...
        
        if addon.Utils then 
            addon.Utils:Log(string.format("Server Response! Status: %s | Return ID: %s | Type: %s", 
                tostring(statusCode), tostring(channelID), tostring(channelType)))
        end
        
        -- Safe Engine Fallback Condition:
        -- Activates if IDs match OR if this is the only voice room available on the client roster
        local channelsList = C_VoiceChat.GetChannelList()
        local isOnlyChannel = channelsList and #channelsList == 1

        if not addon.voiceChannelID or addon.voiceChannelID == channelID or isOnlyChannel then
            addon.voiceChannelID = channelID
            
            if addon.Utils then addon.Utils:Log("Channel successfully registered by game client.") end
            
            -- Route audio capturing streams to the newly initialized audio space
            if C_VoiceChat.ActivateChannel then
                C_VoiceChat.ActivateChannel(channelID)
                if addon.Utils then addon.Utils:Log("Audio device routing activated!") end
            end

            -- Refresh visual components across the window canvas
            if addon.UpdateVoiceUI then
                addon.UpdateVoiceUI()
            end

            -- If hosting local room, broadcast connection details to party members
            if not addon.voiceChannelFromGroup and addon.SendVoiceChannel then
                addon.SendVoiceChannel()
            end
        end
    end
end)

