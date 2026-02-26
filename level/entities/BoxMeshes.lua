local gfx = require("/dynamic/helpers/gfx2.lua")
local colours = {
    0x808080ff, 0x808080ff, -- Weapon (grey)
    0x208060ff, 0x00504cff, -- RoF (dark aqua)
    0xe06020ff, 0xa04000ff, -- Movement speed (vermillion)
    0xa0ff00ff, 0x204000ff, -- Maximum shields (lime)
    0xe08888ff, 0x804444ff, -- Elite I auxiliary firepower
    0x4020d0ff, 0x2010e0ff, -- Elite II poleaxe (indigo)
    0xf4d46cff, 0xfff0c0ff, -- Money to score conversion (light yellow),
    0x802020ff, 0x200000ff -- None (dark red)
}
meshes={}
for i=1,8 do
    meshes[i] = {vertexes={},colors={},segments={}}
    gfx.XYprism(meshes[i], 0, {0,0,0}, i+3, colours[2*i-1], colours[2*i], 32, math.pi/2, 24)
end


-- RoF bonus icon
local bullets = {{-8,12},{8,12},{12,8},{8,4},{-8,4}, {-2,0},{14,0},{18,-4},{14,-8},{-2,-8}, {-18,10},{-12,10},{-20,6},{-12,6}, {-14,-2},{-6,-2},{-12,-6},{-6,-6}}
local j = #meshes[2].vertexes
table.insert(meshes[2].segments, {j,j+1,j+2,j+3,j+4,j})
table.insert(meshes[2].segments, {j+5,j+6,j+7,j+8,j+9,j+5})
table.insert(meshes[2].segments, {j+10,j+11})
table.insert(meshes[2].segments, {j+12,j+13})
table.insert(meshes[2].segments, {j+14,j+15})
table.insert(meshes[2].segments, {j+16,j+17})
for _,v in ipairs(bullets) do
    table.insert(meshes[2].vertexes, v)
    table.insert(meshes[2].colors, 0x30a080ff)
end
-- movement bonus icon
local lightning = {{8,16,12},{0,4,12},{10,4,12},{-6,-16,12},{-4,-2,12},{-10,-2,12},{-2,16,12}}
local j = #meshes[3].vertexes
table.insert(meshes[3].segments, {j,j+1,j+2,j+3,j+4,j+5,j+6,j})
for _,v in ipairs(lightning) do
    table.insert(meshes[3].vertexes, v)
    table.insert(meshes[3].colors, 0xff8020ff)
end
-- shield bonus icon
local plus = {{6,16,12},{6,6,12},{16,6,12},{16,-6,12},{6,-6,12},{6,-16,12},{-6,-16,12},{-6,-6,12},{-16,-6,12},{-16,6,12},{-6,6,12},{-6,16,12}}
local j = #meshes[4].vertexes
table.insert(meshes[4].segments, {j,j+1,j+2,j+3,j+4,j+5,j+6,j+7,j+8,j+9,j+10,j+11,j})
for _,v in ipairs(plus) do
    table.insert(meshes[4].vertexes, v)
    table.insert(meshes[4].colors, 0xc0ff20ff)
end
-- auxiliary weapon icon
local ku = {{12,-20},{-12,0},{12,20}}
local j = #meshes[5].vertexes
table.insert(meshes[5].segments, {j,j+1,j+2})
for _,v in ipairs(ku) do
    table.insert(meshes[5].vertexes, v)
    table.insert(meshes[5].colors, 0xfd8888ff)
end
-- score bonus icon
local o = {{12,12},{12,-12},{-12,-12},{-12,12},{16,16},{-16,-16}}
local j = #meshes[7].vertexes
table.insert(meshes[7].segments, {j,j+1,j+2,j+3,j})
table.insert(meshes[7].segments, {j+4,j+5})
for _,v in ipairs(o) do
    table.insert(meshes[7].vertexes, v)
    table.insert(meshes[7].colors, 0xffd870ff)
end
