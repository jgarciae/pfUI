pfUI:RegisterSkin("Pet Stable Master", "vanilla:tbc:wotlk", function ()
  StripTextures(PetStableFrame)
  CreateBackdrop(PetStableFrame, nil, nil, .75)
  CreateBackdropShadow(PetStableFrame)

  PetStableFrame.backdrop:SetPoint("TOPLEFT", 10, -10)
  PetStableFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 72)
  PetStableFrame:SetHitRectInsets(10,32,10,72)
  EnableMovable(PetStableFrame)

  SkinCloseButton(PetStableFrameCloseButton, PetStableFrame.backdrop, -6, -6)

  PetStableFrame:DisableDrawLayer("BACKGROUND")

  PetStableTitleLabel:ClearAllPoints()
  PetStableTitleLabel:SetPoint("TOP", PetStableFrame.backdrop, "TOP", 0, -10)

  EnableClickRotate(PetStableModel)
  PetStableModelRotateLeftButton:Hide()
  PetStableModelRotateRightButton:Hide()

  PetStablePetInfo:ClearAllPoints()
  PetStablePetInfo:SetPoint("TOPLEFT", PetStableModel, "TOPLEFT", 10, 0)

  local buttons = {"PetStableCurrentPet", "PetStableStabledPet1", "PetStableStabledPet2"}
  -- 3.x has 4 stable slots
  if PetStableStabledPet3 then table.insert(buttons, "PetStableStabledPet3") end
  if PetStableStabledPet4 then table.insert(buttons, "PetStableStabledPet4") end
  for _,v in pairs(buttons) do
    local button = _G[v]
    StripTextures(button)
    SkinButton(button, nil, nil, nil, _G[button:GetName().."IconTexture"])

    button.Enable = function()
      button:SetBackdropColor()
      button.locked = false
    end
    button.Disable = function()
      button:SetBackdropColor(1, .1, .1, .3)
      button.locked = true
    end
  end

  SkinButton(PetStablePurchaseButton)
end)
