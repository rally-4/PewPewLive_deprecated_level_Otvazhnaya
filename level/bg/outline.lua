local w = 512
local h = 1024
local s = 8
local c1 = 0x800000ff
local c2 = 0x80202080
meshes={{
    vertexes={{-w,h},{-w,-h},{w,h},{w,-h}, {-w-s,h},{-w-s,-h},{w+s,h},{w+s,-h}},
    colors={c1,c1,c2,c2, c1,c1,c2,c2},
    segments={{0,1},{2,3}, {4,5},{6,7}}
}}
for _,p in ipairs(meshes[1].vertexes) do
    p[3] = -128
end