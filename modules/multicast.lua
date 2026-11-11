pfUI:RegisterModule("multicast", "wotlk", function ()
  local _, class = UnitClass("player")
  if class ~= "SHAMAN" then return end
  if not MultiCastActionBarFrame then return end

  -- the Blizzard bars are still in place when the actionbar module is disabled
  if C.disabled and C.disabled.actionbar == "1" then return end

  -- The totem bar is a child of the MainMenuBar, which the actionbar module
  -- hides. Move it to a movable anchor instead: Blizzard keeps positioning the
  -- bar relative to its parent (slide animation).
  -- WOTLK-CHECK: reparenting a protected frame, only done outside of combat
  local anchor = CreateFrame("Frame", "pfMultiCast", UIParent)
  anchor:SetWidth(230)
  anchor:SetHeight(4)
  anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 90)
  UpdateMovable(anchor)

  -- UIParent_ManageFramePositions would anchor the bar back to the hidden
  -- MainMenuBar. Removing the entry leaves no tainted value behind for the
  -- secure position manager to read (same as other bar addons do).
  if UIPARENT_MANAGED_FRAME_POSITIONS then
    UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
  end

  local function Attach()
    if InCombatLockdown() then return false end
    -- the xml anchors it to MainMenuBar; the slide code uses GetParent()
    MultiCastActionBarFrame:SetParent(anchor)
    MultiCastActionBarFrame:ClearAllPoints()
    MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", MULTICASTACTIONBAR_XPOS or 30, 0)
    return true
  end

  if not Attach() then
    -- logged in during combat, try again afterwards
    local wait = CreateFrame("Frame")
    wait:RegisterEvent("PLAYER_REGEN_ENABLED")
    wait:SetScript("OnEvent", function()
      if Attach() then this:UnregisterAllEvents() end
    end)
  end

  -- WOTLK-CHECK: UIParent hides the totem bar while ShapeshiftBarFrame or
  -- PossessBarFrame report IsShown() (both stay "shown" inside the hidden
  -- MainMenuBar). Verify the totem bar stays visible for shamans with forms.

  pfUI.multicast = anchor
end)
