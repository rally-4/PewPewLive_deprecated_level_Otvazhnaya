local gfx = require("/dynamic/helpers/gfx2.lua")
local g = (1 + math.sqrt(5))/2 -- golden ratio

--[[
local c2 = 0x78607bff
local c1 = 0xe2c0d2ff
local c0 = 0xffe8c0ff
--]]

local c1 = 0xf3a84bff -- f9e934ff
local c2 = 0x7caee8ff -- 7dddf9ff
local pnk = 0xf4b8e0ff -- ffe0f4ff

-- icosahedron mesh
meshes={{
    vertexes={
        {g,1},{g,-1},{-g,-1},{-g,1},
        {1,0,g},{-1,0,g},{-1,0,-g},{1,0,-g},
        {0,g,1},{0,g,-1},{0,-g,-1},{0,-g,1}
    },
    colors={
        c1,c1,c1,c1,c1,c2,
        c1,c2,c2,c2,c2,c2
    },
    segments={
        {0,1,4,0,7,1,10,7,9,0,8,4,5,8,9,6,3,5,2,6,10,11,2,3,8},
        {6,7},
        {9,3},
        {2,10},
        {5,11,4},
        {1,11}
    }
}}

-- scale faithfully
local r = 24
local m = r/(2*math.sin(2*math.pi/5))
for _,v in ipairs(meshes[1].vertexes) do
    v[1] = v[1] * m
    v[2] = v[2] * m
    if v[3] ~= nil then v[3] = v[3] * m end
end

-- inner halos
local from = .8
local to = 1.2
local step = .1
gfx.recurseLight(meshes[1], {28,0,0}, from, to, step, gfx.ZYpolygon(gfx.empty, #meshes[1].vertexes, {0,0,0}, 24, pnk, 12, 0), true)
gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {32,0,0}, 24, pnk, 16, 0)

-- outer halo
local arcres = 12
gfx.ZYarc(meshes[1], #meshes[1].vertexes, {36,0,0}, 9*math.pi/8, 15*math.pi/8, arcres, pnk, 20)

table.insert(meshes[1].segments, {#meshes[1].vertexes - arcres - 1, #meshes[1].vertexes})
table.insert(meshes[1].segments, {#meshes[1].vertexes - 1, #meshes[1].vertexes + 1})

table.insert(meshes[1].vertexes, {36, 20*math.sin(9*math.pi/8), 20*math.cos(9*math.pi/8) - 6})
table.insert(meshes[1].vertexes, {36, 20*math.sin(15*math.pi/8), 20*math.cos(15*math.pi/8) + 6})

gfx.ZYarc(meshes[1], #meshes[1].vertexes, {36,0,0}, math.pi/8, 7*math.pi/8, arcres, pnk, 20)

table.insert(meshes[1].segments, {#meshes[1].vertexes - arcres - 1, #meshes[1].vertexes})
table.insert(meshes[1].segments, {#meshes[1].vertexes - 1, #meshes[1].vertexes + 1})

table.insert(meshes[1].vertexes, {36, 20*math.sin(math.pi/8), 20*math.cos(math.pi/8) + 6})
table.insert(meshes[1].vertexes, {36, 20*math.sin(7*math.pi/8), 20*math.cos(7*math.pi/8) - 6})

table.insert(meshes[1].vertexes, {36, 0, 18})
table.insert(meshes[1].vertexes, {36, 0, 32})
table.insert(meshes[1].segments, {#meshes[1].vertexes - 2, #meshes[1].vertexes - 1})
table.insert(meshes[1].vertexes, {36, 0, -18})
table.insert(meshes[1].vertexes, {36, 0, -32})
table.insert(meshes[1].segments, {#meshes[1].vertexes - 2, #meshes[1].vertexes - 1})

for i=1,8 do table.insert(meshes[1].colors, pnk) end
