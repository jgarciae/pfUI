pfUI:RegisterSkin("tracking", "tbc:wotlk", function ()
  local button = _G[MINIMAP_TRACKING_FRAME:GetName() .. "Button"]

  if button then
    -- 3.x: MiniMapTracking is a plain Frame (no button textures), the click
    -- handling, border and highlight live in the MiniMapTrackingButton child.
    StripTextures(button)
    button:SetHighlightTexture("")
    button:ClearAllPoints()
    button:SetAllPoints(MINIMAP_TRACKING_FRAME)
    -- the native handlers move the icon by its TOPLEFT point only
    button:SetScript("OnMouseDown", function() MiniMapTrackingIconOverlay:Show() end)
    button:SetScript("OnMouseUp", function() MiniMapTrackingIconOverlay:Hide() end)
    if MiniMapTrackingBackground then MiniMapTrackingBackground:Hide() end

    CreateBackdrop(MINIMAP_TRACKING_FRAME, nil, true)
    HandleIcon(MINIMAP_TRACKING_FRAME, MiniMapTrackingIcon)
  else
    MINIMAP_TRACKING_FRAME:DisableDrawLayer("ARTWORK") -- hide border
    SkinButton(MINIMAP_TRACKING_FRAME, nil, nil, nil, MiniMapTrackingIcon, true)
  end

  MINIMAP_TRACKING_FRAME:SetHeight(tonumber(C.appearance.minimap.tracking_size) + 10)
  MINIMAP_TRACKING_FRAME:SetWidth(tonumber(C.appearance.minimap.tracking_size) + 10)
  MINIMAP_TRACKING_FRAME:ClearAllPoints()
  MINIMAP_TRACKING_FRAME:SetPoint("TOPLEFT", pfUI.minimap, "TOPLEFT", -10, -10)
  MINIMAP_TRACKING_FRAME:SetFrameStrata("LOW")
  MINIMAP_TRACKING_FRAME:SetParent(UIParent)
  UpdateMovable(MINIMAP_TRACKING_FRAME)
end)
