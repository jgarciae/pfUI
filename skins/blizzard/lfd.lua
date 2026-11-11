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
  StripTextures(LFDParentFrame)
  CreateBackdrop(LFDParentFrame, nil, nil, .75)
  CreateBackdropShadow(LFDParentFrame)
  EnableMovable(LFDParentFrame)

  if LFDParentFrameCloseButton then
    SkinCloseButton(LFDParentFrameCloseButton, LFDParentFrame.backdrop, -6, -6)
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
