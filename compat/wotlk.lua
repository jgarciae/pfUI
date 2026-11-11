-- load pfUI environment
setfenv(1, pfUI:GetEnvironment())

if pfUI.expansion ~= "wotlk" then return end

-- [[ Constants ]]--
CASTBAR_EVENT_CAST_DELAY = "UNIT_SPELLCAST_DELAYED"
CASTBAR_EVENT_CHANNEL_DELAY = "UNIT_SPELLCAST_CHANNEL_UPDATE"
CASTBAR_EVENT_CAST_START = "UNIT_SPELLCAST_START"
CASTBAR_EVENT_CHANNEL_START = "UNIT_SPELLCAST_CHANNEL_START"

EVENTS_MINIMAP_ZONE_UPDATE = {"PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ZONE_CHANGED"}

-- order as in VehicleMenuBar.lua (3.3.5)
MICRO_BUTTONS = {
  'CharacterMicroButton',
  'SpellbookMicroButton',
  'TalentMicroButton',
  'AchievementMicroButton',
  'QuestLogMicroButton',
  'SocialsMicroButton',
  'PVPMicroButton',
  'LFDMicroButton',
  'MainMenuMicroButton',
  'HelpMicroButton',
}

-- WOTLK-CHECK: 3.3 nameplates are Frames with the same region/child layout as
-- TBC, but with a native castbar. Placeholder until the wotlk-nameplates rewrite.
NAMEPLATE_OBJECTORDER = { "border", "castborder", "casticon", "glow", "name", "level", "levelicon", "raidicon" }
NAMEPLATE_FRAMETYPE = "Frame"

MINIMAP_TRACKING_FRAME = _G.MiniMapTracking

-- WOTLK-CHECK: friends list uses DynamicScrollFrame + FriendsFrameButtonTemplate
-- in 3.3.5, "FriendsFrameFriendButtonN" no longer exists. socialmod stays disabled.
FRIENDS_NAME_LOCATION = "ButtonTextLocation"

COOLDOWN_FRAME_TYPE = "Cooldown"
LOOT_BUTTON_FRAME_TYPE = "Button"

-- WOTLK-CHECK: GetPlayerBuff is still present in 3.3.5 (deprecated); buff.lua
-- should move to UnitAura in its own commit.
PLAYER_BUFF_START_ID = 0

-- SecureStateHeaderTemplate was removed in 3.0, see SecureHandlerTemplates.xml
ACTIONBAR_SECURE_TEMPLATE_BAR = "SecureHandlerStateTemplate"
ACTIONBAR_SECURE_TEMPLATE_BUTTON = "SecureActionButtonTemplate"
UNITFRAME_SECURE_TEMPLATE = "SecureUnitButtonTemplate"

--[[ WotLK API Extensions ]]--
-- Present the 3.x return values in the vanilla layout the modules expect.
function UnitBuff(unitstr, i)
  local name, rank, icon, count = _G.UnitBuff(unitstr, i)
  return icon, count
end

function UnitDebuff(unitstr, i)
  local name, rank, texture, stacks, dtype = _G.UnitDebuff(unitstr, i)
  return texture, stacks, dtype
end

-- the function GetContainerNumSlots returns numbers for keyrings
function GetContainerNumSlots(bag)
  if bag == -2 and pfUI.bag and not pfUI.bag.showKeyring then
    return 0
  else
    return _G.GetContainerNumSlots(bag)
  end
end

-- map libdebuff to the regular function
libdebuff = {
  ["UnitDebuff"] = function(self, a1, a2, a3)
    return _G.UnitDebuff(a1,a2,a3)
  end
}

-- WOTLK-CHECK: UnitMana/UnitManaMax are kept as aliases of UnitPower in 3.3.5
-- (Blizzard code only uses UnitPower). Fall back so vanilla-style modules work.
if not _G.UnitMana then
  UnitMana = function(unit) return _G.UnitPower(unit) end
  UnitManaMax = function(unit) return _G.UnitPowerMax(unit) end
end

-- 3.x inserted "hasRep" before "isWatched" in GetFactionInfo; drop it so the
-- return layout matches the one pfUI expects from vanilla/tbc.
function GetFactionInfo(index)
  local name, description, standingID, barMin, barMax, barValue, atWarWith,
    canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = _G.GetFactionInfo(index)
  return name, description, standingID, barMin, barMax, barValue, atWarWith,
    canToggleAtWar, isHeader, isCollapsed, isWatched, isChild
end

-- pfUI.SetupCVars (pfUI.lua) runs in the global environment and calls these
-- TBC tutorial helpers. WOTLK-CHECK: neither is defined in the 3.3.5 FrameXML
-- (ClearTutorials is a client API, TutorialFrame_HideAllAlerts is gone).
_G.TutorialFrame_HideAllAlerts = _G.TutorialFrame_HideAllAlerts or function() end
_G.ClearTutorials = _G.ClearTutorials or function() end
