local ch = require("/dynamic/helpers/colorHelper.lua")

local s0 = 0xff
local s1 = 0xe0
local s2 = 0xc0
local s3 = 0xa0
local s4 = 0x80
local s5 = 0x60
local s6 = 0x40

local red = 0xff000000 + s2
local ora = 0xff800000 + s1
local yel = 0xffff2000 + s0

local pur = 0x70609800 + s4
local mag = 0xbc80b400 + s3
local pnk = 0xf0a4e000 + s2

local blu = 0x0000ff00 + s4
local sky = 0x2080ff00 + s3
local cya = 0x40ffff00 + s2

local m = 2.5
meshes={{
    vertexes={{-2*m,0},{2*m,0},{-m,0},{m,0},{-m,m},{m,m},{-m,-m},{m,-m},{-m,0,m},{-m,0,m},{-m,0,-m},{m,0,-m}},
    colors={ora,ora,yel,yel,red,red,red,red,red,red,red,red},
    segments={{0,1},{2,3},{4,5},{6,7},{8,9},{10,11}}
}}

local dsf = 1/255 -- division scale factor to/from "small" and "big" colours
local to = 7
for i = 1, to do
    local v = i/to
    
    local idx = i + 1
    
    local Hc = ch.hueshift(ch.hexnum2smallrgb(yel), 270*v)
    Hc = ch.makeColor(Hc[1]//dsf, Hc[2]//dsf, Hc[3]//dsf, Hc[4]//dsf)
    local Mc = ch.hueshift(ch.hexnum2smallrgb(ora), 270*v)
    Mc = ch.makeColor(Mc[1]//dsf, Mc[2]//dsf, Mc[3]//dsf, Mc[4]//dsf)
    local Sc = ch.hueshift(ch.hexnum2smallrgb(red), 270*v)
    Sc = ch.makeColor(Sc[1]//dsf, Sc[2]//dsf, Sc[3]//dsf, Sc[4]//dsf)
    
    --[[
    local Hmix = ch.colMix(ch.hexnum2rgb(yel), ch.hexnum2rgb(cya), v)
    local Hc = ch.makeColor(Hmix[1], Hmix[2], Hmix[3], Hmix[4]) -- highlight (yellow - cyan)
    local Mmix = ch.colMix(ch.hexnum2rgb(ora), ch.hexnum2rgb(sky), v)
    local Mc = ch.makeColor(Mmix[1], Mmix[2], Mmix[3], Mmix[4]) -- midtone (orange - sky)
    local Smix = ch.colMix(ch.hexnum2rgb(red), ch.hexnum2rgb(blu), v)
    local Sc = ch.makeColor(Smix[1], Smix[2], Smix[3], Smix[4]) -- shadow (red - blue)
    --]]
    meshes[idx] = {vertexes=meshes[1].vertexes,colors={
        Mc,Mc, Hc,Hc, Sc,Sc,Sc,Sc,Sc,Sc,Sc,Sc
    },segments=meshes[1].segments}
end