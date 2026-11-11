pfUI:RegisterSkin("Readycheck", "vanilla:tbc:wotlk", function ()
  -- 3.x: ReadyCheckFrame lives in FrameXML (ReadyCheck.xml) and not in Blizzard_RaidUI
  local wotlk = pfUI.expansion == "wotlk"
  HookAddonOrVariable(wotlk and "ReadyCheckFrame" or "Blizzard_RaidUI", function()
    -- Compatibility
    local update_func
    if ReadyCheckFrame_OnUpdate then -- tbc
      update_func = "ReadyCheckFrame_OnUpdate"
    else -- vanilla
      update_func = "ReadyCheck_OnUpdate"
    end

    -- 3.x: the artwork and text live in ReadyCheckListenerFrame, which is hidden
    -- for the initiator while ReadyCheckFrame itself stays shown (ReadyCheck.lua)
    local readyframe = ReadyCheckListenerFrame or ReadyCheckFrame
    StripTextures(readyframe, true)
    CreateBackdrop(readyframe, nil, nil, .75)
    CreateBackdropShadow(readyframe)

    SkinButton(ReadyCheckFrameYesButton)
    ReadyCheckFrameYesButton:ClearAllPoints()
    ReadyCheckFrameYesButton:SetPoint("RIGHT", ReadyCheckFrame, "BOTTOM", -8, 24)

    SkinButton(ReadyCheckFrameNoButton)
    ReadyCheckFrameNoButton:ClearAllPoints()
    ReadyCheckFrameNoButton:SetPoint("LEFT", ReadyCheckFrame, "BOTTOM", 8, 24)

    ReadyCheckFrameText:ClearAllPoints()
    ReadyCheckFrameText:SetPoint("TOP", ReadyCheckFrame, "TOP", 0, -12)

    -- 3.x has no timeout on ready checks, so there is no countdown bar
    if wotlk then return end

    local frame = CreateFrame("Button", nil, ReadyCheckFrame)
    frame:SetPoint("TOP", ReadyCheckFrameText, "BOTTOM", 0, -6)
    frame:SetWidth(220)
    frame:SetHeight(10)

    frame.bar = CreateFrame("StatusBar", "ReadyCheckFrameStatusBar", ReadyCheckFrame)
    frame.bar:SetStatusBarTexture(pfUI.media["img:bar"])
    frame.bar:SetAllPoints(frame)

    frame.bar.text = frame.bar:CreateFontString("Status", "DIALOG", "GameFontNormal")
    frame.bar.text:SetFontObject(GameFontWhite)
    frame.bar.text:SetFont(pfUI.font_default, 12, "OUTLINE")
    frame.bar.text:SetPoint("CENTER", 0, 0)

    local max
    hooksecurefunc("ShowReadyCheck", function()
      max = ReadyCheckFrame.timer
      frame.bar:SetMinMaxValues(0, max)
    end)

    hooksecurefunc(update_func, function()
      if not ReadyCheckFrame.timer then return end

      local perc = ReadyCheckFrame.timer/max
      frame.bar:SetStatusBarColor(GetColorGradient(perc))
      frame.bar:SetValue(ReadyCheckFrame.timer)
      frame.bar.text:SetText(round(ReadyCheckFrame.timer, 2))
    end)
  end)
end)
