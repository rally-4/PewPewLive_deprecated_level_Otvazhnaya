local gfx = require("/dynamic/helpers/gfx2.lua")
local sHf = math.sqrt(3)/2 -- slated height factor, l * sqrt(3)/2
local Hf = 1/math.sqrt(2) -- height factor, l/sqrt(2) for square pyramids with equilateral triangles
-- For asthetic purposes, I'll use the slated height for the actual pyramid's height
local l = 24 -- side length
local hl = l/2 -- half the side length

local dsp = sHf*l/2; -- displacement from center, so as to center the pyramid at 0, based on the slated height (again, for asthetic purposes)

local pred = 0xd63044ff -- pyramid red. Combination of 0xac0028ff (shadow) and 0xff6060ff (highlight)
local pbla = 0x343854ff -- pyramid black. Combination of 0x020822ff (shadow) and 0x646886ff (highlight). More red by +1
local hred = 0xe02020ff -- halo red.

-- square pyramid mesh
meshes={{
    vertexes={
        {dsp,hl,hl},{dsp,-hl,hl},{dsp,-hl,-hl},{dsp,hl,-hl},{-dsp,0,0}
    },
    colors={
        pbla,pbla,pbla,pbla,pred
    },
    segments={
        {0,1,2,3,0},{0,4,1},{2,4,3}
    }
}}

local R = 32
local r = 0.5
local a = 2*math.asin(r/2)
local arcres = 12
gfx.ZYarc(meshes[1], #meshes[1].vertexes, {0,0,0}, a, 2*math.pi/3 - a, arcres, hred, R)
gfx.ZYarc(meshes[1], #meshes[1].vertexes, {0,0,0}, 2*math.pi/3 + a, 4*math.pi/3 - a, arcres, hred, R)
gfx.ZYarc(meshes[1], #meshes[1].vertexes, {0,0,0}, 4*math.pi/3 + a, 2*math.pi - a, arcres, hred, R)

gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {0,0,R}, 2*arcres, hred, R*r, 0)
gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {0,sHf*R,-R/2}, 2*arcres, hred, R*r, 0)
gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {0,-sHf*R,-R/2}, 2*arcres, hred, R*r, 0)

gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {8,0,R}, 2*arcres, hred, 3*R*r/4, 0)
gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {8,sHf*R,-R/2}, 2*arcres, hred, 3*R*r/4, 0)
gfx.ZYpolygon(meshes[1], #meshes[1].vertexes, {8,-sHf*R,-R/2}, 2*arcres, hred, 3*R*r/4, 0)
