local blu = 0x0000c0ff
local cya = 0x00a0ffff
meshes={{
    vertexes={
        {-8,0},{0,4},{0,-4},{0,0,4},{0,0,-4},{8,0},
        {-4,0},{0,2},{0,-2},{0,0,2},{0,0,-2},{4,0}
    },
    colors={
        blu,blu,blu,blu,blu,blu,
        cya,cya,cya,cya,cya,cya
    },
    segments={
        {0,1,5},{0,2,5},{0,3,5},{0,4,5},
        {6,7,11},{6,8,11},{6,9,11},{6,10,11}
    }
}}
local max = 7
for i=1,max do
    local v = math.ceil(5*i/max)
    meshes[i+1] = {
        vertexes={{-8,0},{0,4},{0,-4},{0,0,4},{0,0,-4},{8,0},{-4,0},{0,2},{0,-2},{0,0,2},{0,0,-2},{4,0}},
        colors={blu,blu,blu,blu,blu,blu,cya,cya,cya,cya,cya,cya},
        segments={{0,1,5},{0,2,5},{0,3,5},{0,4,5},{6,7,11},{6,8,11},{6,9,11},{6,10,11}}
    }
    for idx,c in ipairs(meshes[1].colors) do
        if c == blu then
            meshes[i+1].colors[idx] = c + 0x10100000*v
        else
            meshes[i+1].colors[idx] = c + 0x10000000*v + math.min(0x80000*v, 0xff0000)
        end
    end
end