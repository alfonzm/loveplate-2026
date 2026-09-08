local fromGlsl = require("shaders.fromGlsl")

return {
    effect = fromGlsl("gameboy", "gameboy.glsl", function(shader)

        -- -- https://lospec.com/palette-list/ice-cream-gb
        -- shader:send("palette",
        -- 	{0.486, 0.247, 0.345}, -- #7c3f58
        -- 	{0.922, 0.420, 0.435}, -- #eb6b6f
        -- 	{0.976, 0.659, 0.459}, -- #f9a875
        -- 	{1.000, 0.965, 0.827}  -- #fff6d3
        -- )

        -- -- palette 2
        -- shader:send("palette",
        -- 	{0.216, 0.165, 0.224}, -- #372a39
        -- 	{0.667, 0.392, 0.302}, -- #aa644d
        -- 	{0.471, 0.514, 0.455}, -- #788374
        -- 	{0.961, 0.914, 0.749}  -- #f5e9bf
        -- )

        -- -- palette 3
        -- shader:send("palette",
        -- 	{0.000, 0.188, 0.231}, -- #00303b
        -- 	{1.000, 0.467, 0.467}, -- #ff7777
        -- 	{1.000, 0.808, 0.588}, -- #ffce96
        -- 	{0.945, 0.949, 0.855}  -- #f1f2da
        -- )

        -- -- palette 4
        -- shader:send("palette",
        -- 	{0.173, 0.129, 0.216}, -- #2c2137
        -- 	{0.267, 0.380, 0.463}, -- #446176
        -- 	{0.247, 0.675, 0.584}, -- #3fac95
        -- 	{0.831, 0.937, 0.849}  -- #a1ef8c
        -- )

        -- -- palette 5
        --    shader:send("palette",
        -- 	{0.133, 0.137, 0.137}, -- #222323
        -- 	{1.000, 0.290, 0.863}, -- #ff4adc
        -- 	{0.239, 1.000, 0.596}, -- #3dff98
        -- 	{0.941, 0.965, 0.941}  -- #f0f6f0
        -- )

        -- -- palette 7
        -- shader:send("palette",
        -- 	{0.216, 0.165, 0.318}, -- #372a51
        -- 	{0.227, 0.314, 0.408}, -- #3a5068
        -- 	{0.353, 0.561, 0.471}, -- #5a8f78
        -- 	{0.961, 0.965, 0.875}  -- #f5f6df
        -- )

        -- -- palette 8
        -- shader:send("palette",
        -- 	{0.161, 0.122, 0.243}, -- #291f3e
        -- 	{0.231, 0.475, 0.380}, -- #3b7961
        -- 	{0.392, 0.816, 0.722}, -- #64d0b8
        -- 	{0.957, 0.949, 0.686}  -- #f4f2af
        -- )

        -- -- palette 9
        -- shader:send("palette",
        -- 	{0.208, 0.200, 0.247}, -- #35333f
        -- 	{0.855, 0.204, 0.404}, -- #da3467
        -- 	{1.000, 0.643, 0.604}, -- #ffa49a
        -- 	{0.945, 0.878, 0.804}  -- #f1e0cd
        -- )

        -- -- palette 10
        -- shader:send("palette",
        -- 	{0.157, 0.216, 0.357}, -- #28375b
        -- 	{0.224, 0.502, 0.612}, -- #39809c
        -- 	{0.373, 0.800, 0.525}, -- #5fcc86
        -- 	{1.000, 0.953, 0.482}  -- #fff37b
        -- )

        -- -- palette 11
        -- shader:send("palette",
        -- 	{0.118, 0.286, 0.349}, -- #1e4959
        -- 	{0.231, 0.631, 0.333}, -- #3ba155
        -- 	{0.627, 0.780, 0.435}, -- #a0c76f
        -- 	{0.922, 0.878, 0.698}  -- #ebe0b2
        -- )

        -- -- palette 12
        -- shader:send("palette",
        -- 	{0.204, 0.204, 0.204}, -- #343434
        -- 	{0.482, 0.482, 0.482}, -- #7b7b7b
        -- 	{0.212, 0.678, 0.412}, -- #36ad69
        -- 	{0.886, 0.839, 0.710}  -- #e2d6b5
        -- )

        -- -- https://lospec.com/palette-list/qameboy
        -- shader:send("palette",
        --     Color.fromHex("#353d46"),
        --     Color.fromHex("#42665a"),
        --     Color.fromHex("#739a56"),
        -- 	Color.fromHex("#b2c27d")
        -- )

        -- -- https://lospec.com/palette-list/mist-gb
        -- shader:send("palette",
        --     Color.fromHex("#2d1b00"),
        --     Color.fromHex("#1e606e"),
        --     Color.fromHex("#5ab9a8"),
        --     Color.fromHex("#c4f0c2")
        -- )

        -- -- https://lospec.com/palette-list/nintendo-gameboy-bgb
        -- shader:send("palette",
        --     Color.fromHex("#081820"),
        --     Color.fromHex("#346856"),
        --     Color.fromHex("#88c070"),
        --     Color.fromHex("#e0f8d0")
        -- )

        -- -- https://lospec.com/palette-list/ayy4
        -- shader:send("palette",
        --     Color.fromHex("#00303b"),
        --     Color.fromHex("#ff7777"),
        --     Color.fromHex("#ffce96"),
        --     Color.fromHex("#f1f2da")
        -- )

    end),
}
