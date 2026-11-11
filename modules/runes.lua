pfUI:RegisterModule("runes", "wotlk", function ()
  local _, class = UnitClass("player")
  if class ~= "DEATHKNIGHT" then return end
  if C.runes.enable ~= "1" then return end

  -- the Blizzard rune frame is a child of the (hidden) player frame, but it
  -- keeps listening to rune events
  if RuneFrame then
    RuneFrame:UnregisterAllEvents()
    RuneFrame:Hide()
    RuneFrame.Show = function() return end
  end

  -- 1: blood, 2: unholy, 3: frost, 4: death
  local colors = {
    [1] = { .85, .15, .15 },
    [2] = { .25, .85, .25 },
    [3] = { .25, .60, 1.0 },
    [4] = { .80, .30, 1.0 },
  }

  -- display order of the rune ids, same as RuneFrame.xml + RuneFrame_FixRunes
  local order = { 1, 2, 5, 6, 3, 4 }

  local rawborder, border = GetBorderSize("unitframes")
  local anchor = pfUI.uf and pfUI.uf.player

  local runes = CreateFrame("Frame", "pfRunes", UIParent)
  runes:SetFrameStrata("LOW")
  runes.runes = {}

  for id = 1, 6 do
    local rune = CreateFrame("Frame", "pfRune" .. id, runes)
    rune.id = id

    rune.bar = CreateFrame("StatusBar", nil, rune)
    rune.bar:SetAllPoints()
    rune.bar:SetStatusBarTexture(pfUI.media["img:bar"])
    rune.bar:SetMinMaxValues(0, 1)
    rune.bar:SetValue(1)
    rune.bar:SetOrientation("VERTICAL")
    CreateBackdrop(rune.bar, border)

    rune.text = rune.bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rune.text:SetPoint("CENTER", 0, 0)

    runes.runes[id] = rune
  end

  -- the animation only runs while at least one rune is recharging
  local function OnUpdate()
    if ( this.tick or 0 ) > GetTime() then return else this.tick = GetTime() + .05 end

    local active = nil
    local now = GetTime()
    for id = 1, 6 do
      local rune = this.runes[id]
      if rune.start then
        local elapsed = now - rune.start
        if elapsed >= rune.duration then
          rune.start, rune.duration, rune.left = nil, nil, nil
          rune.bar:SetValue(1)
          rune.bar:SetAlpha(1)
          rune.text:SetText("")
        else
          active = true
          elapsed = elapsed > 0 and elapsed or 0
          rune.bar:SetValue(elapsed / rune.duration)

          -- only touch the text when the displayed second changes
          local left = ceil(rune.duration - elapsed)
          if rune.left ~= left then
            rune.left = left
            rune.text:SetText(C.runes.showtext == "1" and left or "")
          end
        end
      end
    end

    if not active then this:SetScript("OnUpdate", nil) end
  end

  local function UpdateRune(id)
    local rune = runes.runes[id]
    local start, duration, ready = GetRuneCooldown(id)
    local color = colors[GetRuneType(id)] or colors[1]

    rune.bar:SetStatusBarColor(color[1], color[2], color[3], 1)

    if ready or not start or not duration or duration == 0 then
      rune.start, rune.duration, rune.left = nil, nil, nil
      rune.bar:SetValue(1)
      rune.bar:SetAlpha(1)
      rune.text:SetText("")
    else
      rune.start, rune.duration, rune.left = start, duration, nil
      rune.bar:SetAlpha(.5)
      runes:SetScript("OnUpdate", OnUpdate)
    end
  end

  runes:RegisterEvent("PLAYER_ENTERING_WORLD")
  runes:RegisterEvent("RUNE_POWER_UPDATE")
  runes:RegisterEvent("RUNE_TYPE_UPDATE")
  runes:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
      for id = 1, 6 do UpdateRune(id) end
    elseif arg1 and runes.runes[arg1] then
      UpdateRune(arg1)
    end
  end)

  pfUI.runes = runes
  pfUI.runes.UpdateConfig = function()
    local size = tonumber(C.runes.size) or 22
    local spacing = tonumber(C.runes.spacing) or 3
    local font = pfUI.font_unit or pfUI.font_default
    local fontsize = C.global.font_unit_size or C.global.font_size

    runes:SetWidth(6 * size + 5 * spacing)
    runes:SetHeight(size)
    runes:ClearAllPoints()
    if anchor then
      runes:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -border*3)
    else
      runes:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
    end

    for pos = 1, 6 do
      local rune = runes.runes[order[pos]]
      rune:SetWidth(size)
      rune:SetHeight(size)
      rune:ClearAllPoints()
      rune:SetPoint("LEFT", runes, "LEFT", (pos-1) * (size + spacing), 0)
      rune.text:SetFont(font, fontsize, "OUTLINE")
    end

    UpdateMovable(runes)
  end

  pfUI.runes.UpdateConfig()
end)
