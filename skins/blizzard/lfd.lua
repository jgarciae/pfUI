pfUI:RegisterSkin("Dungeon Finder", "wotlk", function ()
  -- LFDFrame.xml is part of FrameXML in 3.3.5
  if not LFDParentFrame then return end

  StripTextures(LFDParentFrame)
  StripTextures(LFDQueueFrame)
  -- WOTLK-CHECK: backdrop covers the full 355x440 frame, insets untested
  CreateBackdrop(LFDParentFrame, nil, nil, .75)
  CreateBackdropShadow(LFDParentFrame)
  EnableMovable(LFDParentFrame)

  -- the close button of LFDParentFrame has no name
  SkinCloseButton(GetNoNameObject(LFDParentFrame, "Button", nil, "UI-Panel-MinimizeButton-Up"), LFDParentFrame.backdrop, -6, -6)

  SkinButton(LFDQueueFrameFindGroupButton)
  SkinButton(LFDQueueFrameCancelButton)
  SkinDropDown(LFDQueueFrameTypeDropDown, nil, nil, nil, true)

  -- the scroll backgrounds get reparented to the scrollbars on load
  for _, scroll in pairs({ "LFDQueueFrameRandomScrollFrame", "LFDQueueFrameSpecificListScrollFrame" }) do
    StripTextures(_G[scroll])
    StripTextures(_G[scroll .. "ScrollBar"])
    SkinScrollbar(_G[scroll .. "ScrollBar"])
  end

  -- popups use a dialog backdrop, replace it like the static popups
  for _, dialog in pairs({ LFDRoleCheckPopup, LFDDungeonReadyDialog }) do
    CreateBackdrop(dialog, nil, true, .75)
    CreateBackdropShadow(dialog)
  end

  SkinButton(LFDRoleCheckPopupAcceptButton)
  SkinButton(LFDRoleCheckPopupDeclineButton)
  SkinButton(LFDDungeonReadyDialogEnterDungeonButton)
  SkinButton(LFDDungeonReadyDialogLeaveQueueButton)
end)
