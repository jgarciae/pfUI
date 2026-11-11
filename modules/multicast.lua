pfUI:RegisterModule("multicast", "wotlk", function ()
  local _, class = UnitClass("player")
  if class ~= "SHAMAN" then return end
  if not MultiCastActionBarFrame then return end

  -- The totem bar is a child of the MainMenuBar, which the actionbar module
  -- hides. Move it to a movable anchor instead: Blizzard keeps positioning the
  -- bar relative to its parent (slide animation), so the anchor is all we need.
  -- WOTLK-CHECK: reparenting a protected frame, only done outside of combat
  local anchor = CreateFrame("Frame", "pfMultiCast", UIParent)
  anchor:SetWidth(230)
  anchor:SetHeight(4)
  anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 90)
  UpdateMovable(anchor)

  local function Attach()
    if InCombatLockdown() then return false end
    MultiCastActionBarFrame:SetParent(anchor)
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

  pfUI.multicast = anchor
end)
