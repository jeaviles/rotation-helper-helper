local RHH = {}

function RHH:init()
   local EventFrame = CreateFrame("frame", "EventFrame")
   EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

   EventFrame:SetScript("OnEvent", function(self, event, ...)
      if(event == "PLAYER_ENTERING_WORLD") then
         local btn = RHH:CreateMainButton()
         RHH:maintainButton(btn)
      end
   end)
end

function RHH:FindSpellKeybinding(spellIDToFind, skipSlot)
   local spellButtons = C_ActionBar.FindSpellActionButtons(spellIDToFind)
   for key,value in pairs(spellButtons) do
      if(skipSlot ~= value) then 
		local buttonName = RHH:GetBindingCommandFromAction(value)
		--print("buttonName", buttonName)
		local bindingKey = GetBindingKey(buttonName)
		--print("bindingKey", bindingKey)
        return RHH:abbreviateKeybind(bindingKey)
      end
   end
   
   return nil
end

-- Helper function to get the correct binding command string from a Blizzard action ID.
-- The indexing seems really strange. Makes me worry that it could change.
-- Like button 1 and 2 are starting at 61 and 49 and then 3 and 4 go lower and 
-- the rest go higher.
function RHH:GetBindingCommandFromAction(actionID)
	--print("actionId:", actionID)
   if not actionID or actionID < 1 then return nil end
   if actionID >= 1 and actionID <= 12 then
      return "ACTIONBUTTON" .. actionID
   elseif actionID >= 61 and actionID <= 72 then
      return "MULTIACTIONBAR1BUTTON" .. (actionID - 60)
   elseif actionID >= 49 and actionID <= 60 then
      return "MULTIACTIONBAR2BUTTON" .. (actionID - 48)
   elseif actionID >= 25 and actionID <= 36 then
      return "MULTIACTIONBAR3BUTTON" .. (actionID - 24)
   elseif actionID >= 37 and actionID <= 48 then
      return "MULTIACTIONBAR4BUTTON" .. (actionID - 36)
	elseif actionID >= 145 and actionID <= 156 then
      return "MULTIACTIONBAR5BUTTON" .. (actionID - 144)
	     elseif actionID >= 157 and actionID <= 168 then
      return "MULTIACTIONBAR6BUTTON" .. (actionID - 156)
	     elseif actionID >= 169 and actionID <= 180 then
      return "MULTIACTIONBAR7BUTTON" .. (actionID - 168)
   end
   return nil
end

function RHH:abbreviateKeybind(inputString)
   if inputString:find("^SHIFT%-") then  -- Check if it starts with "SHIFT-"
      return "S" .. inputString:sub(7)    -- Replace with "S" and the rest
   elseif inputString:find("^CTRL%-") then -- Check if it starts with "CTRL-"
      return "C" .. inputString:sub(6)    -- Replace with "C" and the rest
   elseif inputString:find("^ALT%-") then  -- Check if it starts with "ALT-"
      return "A" .. inputString:sub(5)    -- Replace with "A" and the rest
   else
      return inputString                  -- Return the original string if no match
   end
end

function RHH:CreateMainButton()
    local btn = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
    btn:SetPoint("CENTER")
    btn:SetSize(40, 40)
    btn:SetText("?")
    --btn:Disable()

    return btn
end

--only call once
function RHH:maintainButton(btn)
      C_Timer.NewTicker(0.333, function ()
            local actionButton = C_ActionBar.FindAssistedCombatActionButtons()[1]
            --print("actionButton", actionButton)
            local spellIDToFind = C_AssistedCombat.GetNextCastSpell()
            --print("spellIDToFind", spellIDToFind)
            local keybind = RHH:FindSpellKeybinding(spellIDToFind, actionButton)
            --print("keybind", keybind)
            btn:SetText(keybind)

            -- Play a sound
            --PlaySoundFile("Interface/Addons/MyAddon/sounds/spellchanged.ogg"); -- Replace with your sound file path
               --self:UnregisterEvent(event)
      end)
end

RHH:init()