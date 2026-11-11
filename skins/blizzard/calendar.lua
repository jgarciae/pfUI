pfUI:RegisterSkin("Calendar", "wotlk", function ()
  HookAddonOrVariable("Blizzard_Calendar", function()
    -- WOTLK-CHECK: the day buttons keep their artwork, only frames are skinned
    StripTextures(CalendarFrame)
    CreateBackdrop(CalendarFrame, nil, nil, .75)
    CreateBackdropShadow(CalendarFrame)
    EnableMovable(CalendarFrame)

    if CalendarCloseButton then
      SkinCloseButton(CalendarCloseButton, CalendarFrame.backdrop, -6, -6)
    end

    for _, name in pairs({ "CalendarViewEventFrame", "CalendarViewHolidayFrame",
      "CalendarCreateEventFrame", "CalendarMassInviteFrame", "CalendarEventPickerFrame",
      "CalendarTexturePickerFrame" }) do
      local frame = _G[name]
      if frame then
        StripTextures(frame)
        CreateBackdrop(frame, nil, nil, .75)
      end
    end
  end)
end)
