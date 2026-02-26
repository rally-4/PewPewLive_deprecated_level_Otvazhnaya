-- sRGB into linear RGB
-- Linear RGB into luma
-- Luma scaled such that the brightest is `ff`
-- 
-- Luma is spectrally weighted for normal vision (linear relative to light) but not adjusted for the non-linear perception of lightness
-- 
local s = 3/2 -- scale factor
meshes={{
    vertexes={
        {-8*s,0,2},{-9*s,0,-10*s},{0,0,-4*s},{8*s,0,-3*s},{16*s,0,-3*s}, {2*s,0,-16*s},
        
        {-16*s,12*s,12*s},{-4*s,12*s,7*s},{-3*s,8*s,6*s},{4*s,8*s,4*s},{-3*s,4*s,0},{s,4*s,-2*s},
        {-16*s,-12*s,12*s},{-4*s,-12*s,7*s},{-3*s,-8*s,6*s},{4*s,-8*s,4*s},{-3*s,-4*s,2*s},{s,-4*s,0}
    },
    colors={
        -- 00b0ff -> ff
        -- 0088fd -> a5
        -- 0080f8 -> 94
        -- 0078f0 -> 83
        -- 0070e8 -> 74
        -- 0058d4 -> 4e
        -- 0050d0 -> 45
        -- 004cc8 -> 3e
        -- 0040c0 -> 32
        -- 0030b4 -> 24
        0x949494ff, 0xa5a5a5ff, 0x4e4e4eff, 0x242424ff, 0x00008cff, 0x3e3e3eff,
        
        0xffffffff, 0x838383ff, 0x747474ff, 0x323232ff, 0x838383ff, 0x454545ff,
        0xffffffff, 0x838383ff, 0x747474ff, 0x323232ff, 0x838383ff, 0x454545ff
    },
    segments={
        {0,1,2,3,4},{3,5},
        
        {6,7,8,9,10,11},
        {12,13,14,15,16,17}
    }
}}