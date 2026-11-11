pfUI:RegisterSkin("Achievements", "wotlk", function ()
  local rawborder, border = GetBorderSize()
  local bpad = rawborder > 1 and border - GetPerfectPixel() or GetPerfectPixel()

  HookAddonOrVariable("Blizzard_AchievementUI", function()
    -- the wood border is a frame backdrop (no texture region), replace it
    StripTextures(AchievementFrame)
    CreateBackdrop(AchievementFrame, nil, true, .75)
    CreateBackdropShadow(AchievementFrame)
    EnableMovable(AchievementFrame)

    -- WOTLK-CHECK: only the outer frame, tabs, scrollbars and dropdown are
    -- skinned, the artwork of the individual achievement entries is kept
    SkinCloseButton(AchievementFrameCloseButton, AchievementFrame, -6, -6)

    for i = 1, 2 do
      local tab = _G["AchievementFrameTab"..i]
      local lastTab = _G["AchievementFrameTab"..(i-1)]
      tab:ClearAllPoints()
      if lastTab then
        tab:SetPoint("LEFT", lastTab, "RIGHT", border*2 + 1, 0)
      else
        tab:SetPoint("TOPLEFT", AchievementFrame, "BOTTOMLEFT", bpad, -(border + (border == 1 and 1 or 2)))
      end
      SkinTab(tab)
    end

    for _, scroll in pairs({ "AchievementFrameCategoriesContainerScrollBar",
      "AchievementFrameAchievementsContainerScrollBar", "AchievementFrameStatsContainerScrollBar",
      "AchievementFrameComparisonContainerScrollBar", "AchievementFrameComparisonStatsContainerScrollBar" }) do
      StripTextures(_G[scroll])
      SkinScrollbar(_G[scroll])
    end

    -- custom dropdown (no UIDropDownMenuTemplate), don't open it to measure
    SkinDropDown(AchievementFrameFilterDropDown, nil, nil, nil, true)
  end)
end)
