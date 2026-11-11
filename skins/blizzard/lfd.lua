pfUI:RegisterSkin("Dungeon Finder", "wotlk", function ()
  local function SkinPopup(name, buttons)
    local frame = _G[name]
    if not frame then return end

    StripTextures(frame)
    CreateBackdrop(frame, nil, nil, .75)
    CreateBackdropShadow(frame)

    for _, button in pairs(buttons or {}) do
      if _G[button] then SkinButton(_G[button]) end
    end
  end

  -- WOTLK-CHECK: names of the buttons are taken from LFDFrame.xml
  if not LFDParentFrame or not LFDQueueFrame then return end

  StripTextures(LFDParentFrame)
  CreateBackdrop(LFDParentFrame, nil, nil, .75)
  CreateBackdropShadow(LFDParentFrame)
  EnableMovable(LFDParentFrame)

  -- the close button of LFDParentFrame is anonymous in 3.3.5, search the children
  local closebutton = LFDParentFrameCloseButton
  if not closebutton then
    for _, child in ipairs({ LFDParentFrame:GetChildren() }) do
      if child:GetObjectType() == "Button" and not child:GetName() and child:GetNormalTexture()
        and tostring(child:GetNormalTexture():GetTexture()):find("UI%-Panel%-MinimizeButton") then
        closebutton = child
        break
      end
    end
  end

  if closebutton then
    SkinCloseButton(closebutton, LFDParentFrame.backdrop, -6, -6)
  end

  StripTextures(LFDQueueFrame)
  for _, button in pairs({ "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton" }) do
    if _G[button] then SkinButton(_G[button]) end
  end

  if LFDQueueFrameTypeDropDown then SkinDropDown(LFDQueueFrameTypeDropDown) end
  if LFDQueueFrameRandomScrollFrameScrollBar then SkinScrollbar(LFDQueueFrameRandomScrollFrameScrollBar) end

  SkinPopup("LFDRoleCheckPopup", { "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton" })
  SkinPopup("LFDDungeonReadyDialog", { "LFDDungeonReadyDialogEnterDungeonButton", "LFDDungeonReadyDialogLeaveQueueButton" })
end)
