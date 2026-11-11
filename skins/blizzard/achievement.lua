pfUI:RegisterSkin("Achievements", "wotlk", function ()
  local rawborder, border = GetBorderSize()
  local bpad = rawborder > 1 and border - GetPerfectPixel() or GetPerfectPixel()

  HookAddonOrVariable("Blizzard_AchievementUI", function()
    StripTextures(AchievementFrame)
    CreateBackdrop(AchievementFrame, nil, nil, .75)
    CreateBackdropShadow(AchievementFrame)
    EnableMovable(AchievementFrame)

    -- WOTLK-CHECK: only the outer frame, tabs, scrollbars and dropdown are
    -- skinned, the artwork of the individual achievement entries is kept
    if AchievementFrameCloseButton then
      SkinCloseButton(AchievementFrameCloseButton, AchievementFrame.backdrop, -6, -6)
    end

    for i = 1, 3 do
      local tab = _G["AchievementFrameTab"..i]
      local lastTab = _G["AchievementFrameTab"..(i-1)]
      if tab then
        tab:ClearAllPoints()
        if lastTab then
          tab:SetPoint("LEFT", lastTab, "RIGHT", border*2 + 1, 0)
        else
          tab:SetPoint("TOPLEFT", AchievementFrame.backdrop, "BOTTOMLEFT", bpad, -(border + (border == 1 and 1 or 2)))
        end
        SkinTab(tab)
      end
    end

    for _, scroll in pairs({ "AchievementFrameCategoriesContainerScrollBar",
      "AchievementFrameAchievementsContainerScrollBar", "AchievementFrameStatsContainerScrollBar" }) do
      if _G[scroll] then SkinScrollbar(_G[scroll]) end
    end

    if AchievementFrameFilterDropDown then SkinDropDown(AchievementFrameFilterDropDown) end
  end)
end)
