local addonName, addon = ...

-- Create the main addon layout frame
local frame = CreateFrame("Frame", "SSVMainFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(320, 250)
frame:SetPoint("CENTER")

-- Enable user positioning and dragging
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")

frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

-- Main Header Text
frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
frame.Title:SetPoint("TOP", 0, -5)
frame.Title:SetText("Solo Shuffle Voice")

-- Status Information Lines
frame.Status = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.Status:SetPoint("TOPLEFT", 20, -45)
frame.Status:SetText("Status: Waiting")

frame.Players = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.Players:SetPoint("TOPLEFT", 20, -70)
frame.Players:SetText("Players with addon: 1") -- Counts you by default

frame.Channel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.Channel:SetPoint("TOPLEFT", 20, -95)
frame.Channel:SetText("Channel: None")

-- Action Button: Connect to Audio Channels
local joinButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
joinButton:SetSize(140, 35)
joinButton:SetPoint("BOTTOM", 0, 45)
joinButton:SetText("Join Voice")

joinButton:SetScript("OnClick", function()
    if addon.JoinVoice then
        addon.JoinVoice()
    end
end)

-- Action Button: Force Refresh UI properties
local refreshButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
refreshButton:SetSize(100, 30)
refreshButton:SetPoint("BOTTOM", 0, 10)
refreshButton:SetText("Refresh")

refreshButton:SetScript("OnClick", function()
    if addon.UpdateVoiceUI then
        addon.UpdateVoiceUI()
    end
end)

-- Global UI state updater called by Network or Voice layers
function addon.UpdateVoiceUI()
    -- Prioritize tracking group hosted channels over generating our own
    if addon.voiceChannelFromGroup then
        frame.Status:SetText("Status: Team Channel Found")
        frame.Channel:SetText("Channel: " .. addon.voiceChannelFromGroup)
        joinButton:SetText("Connect to Team")
    elseif addon.voiceChannelName then
        frame.Status:SetText("Status: Hosting Channel")
        frame.Channel:SetText("Channel: " .. addon.voiceChannelName)
        joinButton:SetText("Reconnect Voice")
    else
        frame.Status:SetText("Status: Waiting for Round")
        frame.Channel:SetText("Channel: None")
        joinButton:SetText("Join Voice")
    end

    -- Dynamically track online active peers with your addon
    local count = 1 -- You have the addon installed
    if addon.players then
        for _ in pairs(addon.players) do
            count = count + 1
        end
    end
    frame.Players:SetText("Players with addon: " .. tostring(count))
end

-- External Hook to trigger fresh checks when network data arrives
function addon.UpdatePlayerList()
    if addon.UpdateVoiceUI then
        addon.UpdateVoiceUI()
    end
end

-- External Hook when a message contains team voice information
function addon.OnChannelReceived(channelName)
    if addon.UpdateVoiceUI then
        addon.UpdateVoiceUI()
    end
end

-- Hide by default on profile load; handled by Arena.lua triggers
frame:Hide()
addon.MainFrame = frame

