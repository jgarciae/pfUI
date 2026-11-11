pfUI:RegisterSkin("Talents", "vanilla:tbc:wotlk", function ()
  local rawborder, border = GetBorderSize()
  local bpad = rawborder > 1 and border - GetPerfectPixel() or GetPerfectPixel()

  HookAddonOrVariable("Blizzard_TalentUI", function()
    -- Compatibility
    local TALENT_FRAME, TALENT_FRAME_NAME
    if PlayerTalentFrame then -- tbc
      TALENT_FRAME = _G.PlayerTalentFrame
    else -- vanilla
      TALENT_FRAME = _G.TalentFrame
    end
    TALENT_FRAME_NAME = TALENT_FRAME:GetName()


    StripTextures(TALENT_FRAME)
    CreateBackdrop(TALENT_FRAME, nil, nil, .75)
    CreateBackdropShadow(TALENT_FRAME)

    TALENT_FRAME.backdrop:SetPoint("TOPLEFT", 10, -10)
    TALENT_FRAME.backdrop:SetPoint("BOTTOMRIGHT", -32, 72)
    TALENT_FRAME:SetHitRectInsets(10,32,10,72)
    EnableMovable(TALENT_FRAME)

    TALENT_FRAME:DisableDrawLayer("BACKGROUND")
    if _G[TALENT_FRAME_NAME.."CancelButton"] then _G[TALENT_FRAME_NAME.."CancelButton"]:Hide() end

    _G[TALENT_FRAME_NAME.."TitleText"]:ClearAllPoints()
    _G[TALENT_FRAME_NAME.."TitleText"]:SetPoint("TOP", TALENT_FRAME.backdrop, "TOP", 0, -10)
    -- 3.x: SpentPointsText inside the points bar
    local spent = _G[TALENT_FRAME_NAME.."SpentPoints"] or _G[TALENT_FRAME_NAME.."SpentPointsText"]
    if spent then
      spent:ClearAllPoints()
      spent:SetPoint("TOP", TALENT_FRAME.backdrop, "TOP", 0, -48)
    end

    SkinCloseButton(_G[TALENT_FRAME_NAME.."CloseButton"], TALENT_FRAME.backdrop, -6, -6)

    StripTextures(_G[TALENT_FRAME_NAME.."ScrollFrame"])
    SkinScrollbar(_G[TALENT_FRAME_NAME.."ScrollFrameScrollBar"])

    _G[TALENT_FRAME_NAME.."TalentPointsText"]:ClearAllPoints()
    _G[TALENT_FRAME_NAME.."TalentPointsText"]:SetPoint("BOTTOMRIGHT", TALENT_FRAME, "BOTTOMRIGHT", -65, 83)

    for i = 1, (MAX_NUM_TALENTS or 40) do
      local talent = _G[TALENT_FRAME_NAME.."Talent"..i]
      if talent then
        StripTextures(talent)
        SkinButton(talent, nil, nil, nil, _G[TALENT_FRAME_NAME.."Talent"..i.."IconTexture"])

        local rank = _G[TALENT_FRAME_NAME.."Talent"..i.."Rank"]
        if rank then rank:SetFont(pfUI.font_default, C.global.font_size, "OUTLINE") end
      end
    end

    _G[TALENT_FRAME_NAME.."Tab1"]:ClearAllPoints()
    _G[TALENT_FRAME_NAME.."Tab1"]:SetPoint("TOPLEFT", TALENT_FRAME.backdrop, "BOTTOMLEFT", bpad, -(border + (border == 1 and 1 or 2)))
    for i = 1, 5 do
      local tab = _G[TALENT_FRAME_NAME.."Tab"..i]
      local lastTab = _G[TALENT_FRAME_NAME.."Tab"..(i-1)]
      if tab then
        if lastTab then
          tab:ClearAllPoints()
          tab:SetPoint("LEFT", lastTab, "RIGHT", border*2 + 1, 0)
        end
        SkinTab(tab)
      end
    end

    -- 3.x: points/preview bars, learn/reset/activate buttons
    -- WOTLK-CHECK: glyph tab and the spec tabs on the side are not skinned yet
    -- (PointsLeft/Middle/Right are textures of StatusFrame, not frames)
    for _, bar in pairs({ "PointsBar", "PreviewBar", "PreviewBarFiller", "StatusFrame" }) do
      local object = _G[TALENT_FRAME_NAME..bar]
      if object then StripTextures(object) end
    end

    for _, button in pairs({ "ActivateButton", "LearnButton", "ResetButton" }) do
      local object = _G[TALENT_FRAME_NAME..button]
      if object then SkinButton(object) end
    end
  end)
end)
