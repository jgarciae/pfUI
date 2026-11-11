pfUI:RegisterSkin("Calendar", "wotlk", function ()
  HookAddonOrVariable("Blizzard_Calendar", function()
    -- WOTLK-CHECK: the day buttons keep their artwork, only frames are skinned
    StripTextures(CalendarFrame)
    CreateBackdrop(CalendarFrame, nil, nil, .75)
    CreateBackdropShadow(CalendarFrame)
    EnableMovable(CalendarFrame)

    SkinCloseButton(CalendarCloseButton, CalendarFrame.backdrop, -6, -6)

    -- event and dialog frames draw a dialog border backdrop, replace it
    for _, name in pairs({ "CalendarViewHolidayFrame", "CalendarViewRaidFrame",
      "CalendarViewEventFrame", "CalendarCreateEventFrame", "CalendarMassInviteFrame",
      "CalendarEventPickerFrame", "CalendarTexturePickerFrame" }) do
      local frame = _G[name]
      StripTextures(frame)
      CreateBackdrop(frame, nil, true, .75)
      CreateBackdropShadow(frame)
    end

    for _, name in pairs({ "CalendarViewHolidayCloseButton", "CalendarViewRaidCloseButton",
      "CalendarViewEventCloseButton", "CalendarCreateEventCloseButton", "CalendarMassInviteCloseButton" }) do
      SkinCloseButton(_G[name], _G[name]:GetParent(), -6, -6)
    end

    for _, name in pairs({ "CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton",
      "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton",
      "CalendarCreateEventInviteButton", "CalendarCreateEventMassInviteButton",
      "CalendarCreateEventRaidInviteButton", "CalendarCreateEventCreateButton",
      "CalendarMassInviteGuildAcceptButton", "CalendarEventPickerCloseButton",
      "CalendarTexturePickerCancelButton", "CalendarTexturePickerAcceptButton" }) do
      SkinButton(_G[name])
    end
  end)
end)
