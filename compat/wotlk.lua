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

-- 3.3.5 nameplates are unnamed WorldFrame children (children: healthbar, castbar).
-- Region order of the plate: threat glow, health border, cast border, cast
-- shield, spell icon, mouseover highlight, name, level, boss icon, raid icon,
-- elite icon (the cast regions only moved into the castbar in 4.x).
-- The castbar is native and mirrored by the module.
NAMEPLATE_OBJECTORDER = { "threat", "border", "castborder", "castshield", "casticon", "glow", "name", "level", "levelicon", "raidicon", "elite" }
NAMEPLATE_FRAMETYPE = "Frame"
NAMEPLATE_BORDER_TEXTURE = "Interface\\TargetingFrame\\UI-TargetingFrame-Flash"
NAMEPLATE_NATIVE_CASTBAR = true

MINIMAP_TRACKING_FRAME = _G.MiniMapTracking

-- WOTLK-CHECK: friends list uses DynamicScrollFrame + FriendsFrameButtonTemplate
-- in 3.3.5, "FriendsFrameFriendButtonN" no longer exists. socialmod stays disabled.
FRIENDS_NAME_LOCATION = "ButtonTextLocation"

COOLDOWN_FRAME_TYPE = "Cooldown"
LOOT_BUTTON_FRAME_TYPE = "Button"

-- 3.x loot rolls: need/greed eligibility and the disenchant button (roll.lua)
ROLL_HAS_DISENCHANT = true

-- WOTLK-CHECK: GetPlayerBuff is still present in 3.3.5 (deprecated); buff.lua
-- should move to UnitAura in its own commit.
PLAYER_BUFF_START_ID = 0

-- SecureStateHeaderTemplate was removed in 3.0, see SecureHandlerTemplates.xml
ACTIONBAR_SECURE_TEMPLATE_BAR = "SecureHandlerStateTemplate"
ACTIONBAR_SECURE_TEMPLATE_BUTTON = "SecureActionButtonTemplate"
UNITFRAME_SECURE_TEMPLATE = "SecureUnitButtonTemplate"

-- interface option globals (UVAR) that 3.x persists through a cvar, taken
-- from uvarInfo in InterfaceOptionsFrame.lua (gui.lua, pfUI.SetupCVars)
UVAR_CVARS = {}
for uvar, setting in pairs(_G.uvarInfo) do
  UVAR_CVARS[uvar] = setting.cvar
end

--[[ WotLK API Extensions ]]--
-- Present the 3.x return values in the vanilla layout the modules expect.
function UnitBuff(unitstr, i)
  local name, rank, icon, count = _G.UnitBuff(unitstr, i)
  return icon, count
end

-- TBC layout (name, rank, icon, count, duration, timeleft) used by the unitframes
-- for hot/buff timers. 3.x returns (name, rank, icon, count, dtype, duration, expirationTime).
function UnitBuffTimed(unitstr, i)
  local name, rank, icon, count, dtype, duration, expiration = _G.UnitBuff(unitstr, i)
  if not name then return end
  if duration == 0 then duration = nil end
  local timeleft = (expiration and expiration > 0) and (expiration - GetTime()) or nil
  return name, rank, icon, count, duration, timeleft
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

-- map libdebuff to the native aura data. expirationTime is a GetTime()
-- timestamp in 3.x, convert it to the remaining time pfUI expects.
local function AuraData(unit, index, filter)
  local name, rank, icon, count, dtype, duration, expiration, caster = _G.UnitAura(unit, index, filter)
  if not name then return end
  local timeleft = (expiration and expiration > 0) and (expiration - GetTime()) or nil
  if duration == 0 then duration = nil end
  return name, rank, icon, count, dtype, duration, timeleft, caster
end

libdebuff = {
  ["UnitDebuff"] = function(self, unit, index)
    return AuraData(unit, index, "HARMFUL")
  end,
  ["UnitOwnDebuff"] = function(self, unit, index)
    return AuraData(unit, index, "HARMFUL|PLAYER")
  end,
}

-- WOTLK-CHECK: UnitMana/UnitManaMax are kept as aliases of UnitPower in 3.3.5
-- (Blizzard code only uses UnitPower). Fall back so vanilla-style modules work.
if not _G.UnitMana then
  UnitMana = _G.UnitPower
  UnitManaMax = _G.UnitPowerMax
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

-- UnitReactionColor is no longer a Blizzard global in 3.3.5; keep the vanilla values
UnitReactionColor = _G.UnitReactionColor or {
  { r = 1.0, g = 0.0, b = 0.0 },
  { r = 1.0, g = 0.0, b = 0.0 },
  { r = 1.0, g = 0.5, b = 0.0 },
  { r = 1.0, g = 1.0, b = 0.0 },
  { r = 0.0, g = 1.0, b = 0.0 },
  { r = 0.0, g = 1.0, b = 0.0 },
  { r = 0.0, g = 1.0, b = 0.0 },
  { r = 0.0, g = 1.0, b = 0.0 },
}

--[[ Player aura API ]]--
-- GetPlayerBuff and friends are gone from the 3.x FrameXML (Blizzard uses
-- UnitAura). Emulate the TBC interface on top of UnitAura so buff/buffwatch
-- keep working. The "buff id" encodes the filter: 1..n for buffs, 1000+n for
-- debuffs, -1 when there is no such aura.
-- WOTLK-CHECK: GetPlayerBuff may still exist natively in 3.3.5; these wrappers
-- shadow it inside the pfUI environment only.
local function DecodeBuffID(bid)
  if bid >= 1000 then return bid - 1000, "HARMFUL" end
  return bid, "HELPFUL"
end

function GetPlayerBuff(index, filter)
  local name, _, _, _, _, duration = _G.UnitAura("player", index, filter)
  if not name then return -1 end
  local bid = (filter and strfind(filter, "HARMFUL")) and (1000 + index) or index
  return bid, (duration == 0 and 1 or nil)
end

function GetPlayerBuffTexture(bid)
  if not bid or bid < 0 then return end
  local index, filter = DecodeBuffID(bid)
  local _, _, icon = _G.UnitAura("player", index, filter)
  return icon
end

function GetPlayerBuffTimeLeft(bid)
  if not bid or bid < 0 then return 0 end
  local index, filter = DecodeBuffID(bid)
  local _, _, _, _, _, _, expiration = _G.UnitAura("player", index, filter)
  return (expiration and expiration > 0) and (expiration - GetTime()) or 0
end

function GetPlayerBuffApplications(bid)
  if not bid or bid < 0 then return 0 end
  local index, filter = DecodeBuffID(bid)
  local _, _, _, count = _G.UnitAura("player", index, filter)
  return count or 0
end

function GetPlayerBuffDispelType(bid)
  if not bid or bid < 0 then return end
  local index, filter = DecodeBuffID(bid)
  local _, _, _, _, dtype = _G.UnitAura("player", index, filter)
  return dtype
end

function CancelPlayerBuff(bid)
  if not bid or bid < 0 then return end
  local index, filter = DecodeBuffID(bid)
  _G.CancelUnitBuff("player", index, filter)
end

-- only fill the gap, never replace a native tooltip method
local tooltipmethods = getmetatable(_G.GameTooltip).__index
if not tooltipmethods.SetPlayerBuff then
  tooltipmethods.SetPlayerBuff = function(self, bid)
    if not bid or bid < 0 then return end
    local index, filter = DecodeBuffID(bid)
    self:SetUnitAura("player", index, filter)
  end
end

-- PLAYER_AURAS_CHANGED was replaced by UNIT_AURA (arg1 == "player") in 3.0
PLAYER_AURA_EVENT = "UNIT_AURA"

-- PLAYER_COMBO_POINTS is gone in 3.x, UNIT_COMBO_POINTS covers it
NO_PLAYER_COMBO_EVENT = true

--[[ Chat edit box ]]--
-- vanilla/tbc have one global ChatFrameEditBox, 3.x has one edit box per chat
-- window. Modules that only query or insert text work through this proxy,
-- which forwards every call to the currently active edit box (or the first one).
-- WOTLK-CHECK: SetScript/GetScript/AddHistoryLine hit the active box only.
local function ActiveEditBox()
  return _G.ChatEdit_GetActiveWindow() or _G.ChatFrame1EditBox
end

-- the 3.x "im" chat style keeps the edit boxes shown while nobody types, so
-- the legacy box counts as shown/visible only while one is actually active
local function EditBoxActive()
  return _G.ChatEdit_GetActiveWindow() and 1 or nil
end

-- method forwarders are cached per key (no closure per call) and resolve the
-- active edit box on each call. No vararg expressions: this file must still
-- parse on the vanilla (Lua 5.0) client before it returns early.
local editboxmethods = {}
ChatFrameEditBox = setmetatable({}, { __index = function(_, key)
  if key == "IsShown" or key == "IsVisible" then return EditBoxActive end
  local value = ActiveEditBox()[key]
  if type(value) == "function" then
    if not editboxmethods[key] then
      editboxmethods[key] = function(_, a1, a2, a3, a4, a5, a6, a7, a8, a9)
        local editbox = ActiveEditBox()
        return editbox[key](editbox, a1, a2, a3, a4, a5, a6, a7, a8, a9)
      end
    end
    return editboxmethods[key]
  end
  return value
end })

ChatFrameEditBoxLanguage = _G.ChatFrame1EditBoxLanguage

-- 3.x added a leading "self" argument (menu callback) to FCF_SetChatWindowFontSize,
-- keep the (chatFrame, fontSize) signature of vanilla/tbc.
function FCF_SetChatWindowFontSize(chatFrame, fontSize)
  return _G.FCF_SetChatWindowFontSize(nil, chatFrame, fontSize)
end

-- 3.x moved the dropdown frame to the first argument of the UIDropDownMenu
-- setters; keep the vanilla/tbc (value, frame) order for pfUI callers.
function UIDropDownMenu_SetWidth(width, frame, padding)
  return _G.UIDropDownMenu_SetWidth(frame, width, padding)
end

function UIDropDownMenu_SetButtonWidth(width, frame)
  return _G.UIDropDownMenu_SetButtonWidth(frame, width)
end

function UIDropDownMenu_SetText(text, frame)
  return _G.UIDropDownMenu_SetText(frame, text)
end

function UIDropDownMenu_JustifyText(justification, frame)
  return _G.UIDropDownMenu_JustifyText(frame, justification)
end

-- 3.x CombatFeedback_OnCombatEvent/OnUpdate take the frame as first argument,
-- vanilla/tbc read it from `this`. Keep the old signatures for unitframes.
function CombatFeedback_OnCombatEvent(event, flags, amount, type)
  return _G.CombatFeedback_OnCombatEvent(this, event, flags, amount, type)
end

function CombatFeedback_OnUpdate(elapsed)
  return _G.CombatFeedback_OnUpdate(this, elapsed)
end

-- 3.x added overhealing and absorbed before "critical" in the SPELL_HEAL
-- combat log suffix: (amount, overhealing, absorbed, critical) = arg12..arg15.
-- tbc: (amount, critical) = arg12, arg13. Used by libpredict.
COMBATLOG_HEAL_CRIT_ARG = "arg15"

-- GetItemInfo accepts cached item names and returns complete item links,
-- GetItemLinkByName (api.lua) uses it instead of scanning item ids.
ITEMLINK_BY_NAME = true

-- UnitHealth reports real values for every unit, libhealth estimation is
-- not required and registers no events.
UNITHEALTH_NATIVE = true

-- ManaBarColor was renamed to PowerBarColor in 3.x (numeric indices kept)
ManaBarColor = _G.ManaBarColor or _G.PowerBarColor

-- additional unit events needed by 3.x unitframes: runic power (death
-- knights) and vehicles; registered by api/unitframes.lua when defined.
UNITFRAME_EXTRA_EVENTS = {
  "UNIT_RUNIC_POWER", "UNIT_MAXRUNIC_POWER",
  "UNIT_ENTERED_VEHICLE", "UNIT_EXITED_VEHICLE",
}

-- 3.x GetComboPoints(unit, target) needs the unit that owns the points (player
-- or vehicle); vanilla/tbc take no (or an ignored) argument.
function GetComboPoints()
  local unit = (_G.UnitHasVehicleUI and _G.UnitHasVehicleUI("player")) and "vehicle" or "player"
  return _G.GetComboPoints(unit, "target")
end

-- actionbar: PLAYER_AURAS_CHANGED is gone in 3.x, the stance buttons refresh
-- through the shapeshift events instead. Vehicle/possess bars switch with
-- UPDATE_BONUS_ACTIONBAR which is already part of the global events.
ACTIONBAR_EXTRA_AURA_EVENTS = { "UPDATE_SHAPESHIFT_FORM", "UPDATE_SHAPESHIFT_USABLE", "UPDATE_SHAPESHIFT_COOLDOWN" }
