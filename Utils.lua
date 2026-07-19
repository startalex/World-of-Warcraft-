-- Grab the private shared folder provided by the WoW engine
local addonName, addonNamespace = ...

-- Create a container for our helper functions
addonNamespace.Utils = {}
local Utils = addonNamespace.Utils

-- A standard colored print function to help you debug in the chat window
function Utils:Log(message)
    print(string.format("|cff00ffcc[SoloVoice]|r: %s", tostring(message)))
end

