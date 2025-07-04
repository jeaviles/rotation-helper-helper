--Does some stuff on button click
btn:SetScript("OnClick", function(self, button, down)
      local spellIDToFind = C_AssistedCombat.GetNextCastSpell()
	  --print("spellIDToFind", spellIDToFind)
	  local actionButton = C_ActionBar.FindAssistedCombatActionButtons()[1]
	  --print("actionButton", actionButton)
      local keybind = RHH:FindSpellKeybinding(spellIDToFind, actionButton)
      --print("keybind", keybind)
      btn:SetText(keybind)
end)
btn:RegisterForClicks("AnyDown", "AnyUp")

--gets the key that has the provided binding
--print(GetBindingByKey("SHIFT-V"))

--gets a stream of events to the ui
--/etrace