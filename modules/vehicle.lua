pfUI:RegisterModule("vehicle", "wotlk", function ()
  -- The Blizzard MainMenuBar is hidden by the actionbar module, which also hides
  -- everything parented to it: the "leave vehicle" button and the micro buttons.

  -- restore the pfUI micro button layout after the vehicle ui gave them back
  if pfUI.panel and pfUI.panel.microbutton and pfUI.panel.microbutton.Anchor then
    hooksecurefunc("VehicleMenuBar_MoveMicroButtons", function(skinName)
      if not skinName then pfUI.panel.microbutton.Anchor() end
    end)
  end

  -- own vehicle exit button, shown whenever the player is able to leave
  local leave = CreateFrame("Button", "pfVehicleLeave", UIParent)
  leave:SetWidth(32)
  leave:SetHeight(32)
  leave:SetFrameStrata("HIGH")
  leave:SetPoint("BOTTOM", pfUI.bars and pfUI.bars[1] or UIParent, "TOP", 0, 10)
  leave:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  leave:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  leave:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Highlight")
  for _, texture in pairs({ leave:GetNormalTexture(), leave:GetPushedTexture() }) do
    texture:SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
  end
  leave:GetHighlightTexture():SetTexCoord(0.130625, 0.879375, 0.130625, 0.879375)
  CreateBackdrop(leave)
  leave:Hide()
  UpdateMovable(leave)

  leave:SetScript("OnClick", function() VehicleExit() end)
  leave:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText(LEAVE_VEHICLE)
    GameTooltip:Show()
  end)
  leave:SetScript("OnLeave", function() GameTooltip:Hide() end)

  leave:RegisterEvent("PLAYER_ENTERING_WORLD")
  leave:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
  leave:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
  leave:RegisterEvent("VEHICLE_UPDATE")
  leave:RegisterEvent("UNIT_ENTERED_VEHICLE")
  leave:RegisterEvent("UNIT_EXITED_VEHICLE")
  leave:SetScript("OnEvent", function()
    if event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
      if arg1 ~= "player" then return end
    end

    -- protected frame, changes during combat are applied afterwards
    if InCombatLockdown() then return end

    if CanExitVehicle() then this:Show() else this:Hide() end
  end)
end)
