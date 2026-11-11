pfUI:RegisterSkin("Glyphs", "wotlk", function ()
  HookAddonOrVariable("Blizzard_GlyphUI", function()
    -- the glyph frame lives inside the talent frame, drop its own background
    -- and let the talent frame backdrop show through
    -- WOTLK-CHECK: glyph sockets keep their native artwork
    StripTextures(GlyphFrame)
  end)
end)
