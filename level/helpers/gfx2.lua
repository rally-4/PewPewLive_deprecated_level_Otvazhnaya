local ch=require("/dynamic/helpers/colorHelper.lua")
gfx2={}
gfx2.empty={vertexes={},colors={},segments={}}
function gfx2.addLines(mesh, meshVertexCount, verts, cols, close)
    local segments = {}
    for i=1,#verts do
        table.insert(mesh.vertexes, verts[i])
        table.insert(mesh.colors, cols[i])
    end
    table.insert(segments, meshVertexCount)
    for i=1,#verts-1 do
        table.insert(segments, meshVertexCount+i)
    end
    if close then
        table.insert(segments, meshVertexCount)
    end
    table.insert(mesh.segments, segments)
end

function gfx2.ZYarc(mesh, meshVertexCount, P, ang1, ang2, sides, col, radius)
    local x,y,z = P[1],P[2],P[3]
    local verts = {}
    local cols = {}
    local step = (ang2 - ang1)/sides
    for a = ang1, ang2 + .001, step do
        table.insert(verts, {x, y + radius * math.sin(a), z + radius * math.cos(a)})
        table.insert(cols, col)
    end
    gfx2.addLines(mesh, meshVertexCount, verts, cols, false)
    return mesh
end

function gfx2.XYpolygon(mesh, meshVertexCount, P, sides, col, radius, tilt)
    local x,y,z = P[1],P[2],P[3]
    local verts = {}
    local cols = {}
    local step = 2*math.pi/sides
    for i=1,sides do
        local ang = i*step+tilt
        table.insert(verts, {x + radius * math.cos(ang), y + radius * math.sin(ang), z})
        table.insert(cols, col)
    end
    gfx2.addLines(mesh, meshVertexCount, verts, cols, true)
    return mesh
end
function gfx2.ZYpolygon(mesh, meshVertexCount, P, sides, col, radius, tilt)
    local x,y,z = P[1],P[2],P[3]
    local verts = {}
    local cols = {}
    local step = 2*math.pi/sides
    for i=1,sides do
        local ang = i*step+tilt
        table.insert(verts, {x, y + radius * math.sin(ang), z + radius * math.cos(ang)})
        table.insert(cols, col)
    end
    gfx2.addLines(mesh, meshVertexCount, verts, cols, true)
    return mesh
end

function gfx2.XYprism(mesh, meshVertexCount, P, sides, col1, col2, radius, tilt, height)
    local x,y,z = P[1],P[2],P[3]
    local step = 2*math.pi/sides
    for i=1,sides do
        local ang = i*step+tilt
        table.insert(mesh.vertexes, {x + radius * math.cos(ang), y + radius * math.sin(ang), z + height})
        table.insert(mesh.vertexes, {x + radius * math.cos(ang), y + radius * math.sin(ang), z - height})
        
        local c = meshVertexCount + 2*i-2
        table.insert(mesh.segments, {c, c+1})
        if i ~= 1 then
            table.insert(mesh.segments, {c-2, c})
            table.insert(mesh.segments, {c-1, c+1})
        end
        table.insert(mesh.colors, col1)
        table.insert(mesh.colors, col2)
    end
    table.insert(mesh.segments, {meshVertexCount, 2*sides-2})
    table.insert(mesh.segments, {meshVertexCount+1, 2*sides-1})
    return mesh
end

function gfx2.XYhollowPolygram(mesh, meshVertexCount, P, sides, skips, col, radius, tilt)
    local x,y,z = P[1],P[2],P[3]
    local verts = {}
    local cols = {}
    local step = 2*math.pi/sides
    local A = .5*(sides - 2*skips + 2)*math.pi / sides
    local innerRadius = radius * math.cos(math.pi/sides) - radius * math.sin(math.pi/sides) * math.cos(A)/math.sin(A)
    for i=1,sides do
        local ang = i*step+tilt
        table.insert(verts, {x + radius * math.cos(ang), y + radius * math.sin(ang), z})
        table.insert(verts, {x + innerRadius * math.cos(ang + step/2), y + innerRadius * math.sin(ang + step/2), z})
        table.insert(cols, col)
        table.insert(cols, col)
    end
    gfx2.addLines(mesh, meshVertexCount, verts, cols, true)
    return mesh
end
function gfx2.ZYhollowPolygram(mesh, meshVertexCount, P, sides, skips, col, radius, tilt)
    local x,y,z = P[1],P[2],P[3]
    local verts = {}
    local cols = {}
    local step = 2*math.pi/sides
    local A = .5*(sides - 2*skips + 2)*math.pi / sides
    local innerRadius = radius * math.cos(math.pi/sides) - radius * math.sin(math.pi/sides) * math.cos(A)/math.sin(A)
    for i=1,sides do
        local ang = i*step+tilt
        table.insert(verts, {x, y + radius * math.sin(ang), z + radius * math.cos(ang)})
        table.insert(verts, {x, y + innerRadius * math.sin(ang + step/2), z + innerRadius * math.cos(ang + step/2)})
        table.insert(cols, col)
        table.insert(cols, col)
    end
    gfx2.addLines(mesh, meshVertexCount, verts, cols, true)
    return mesh
end

function gfx2.sphere(mesh, vertexCount, P, detail, col1, col2, radius)
    local x,y = P[1],P[2]
    local verts = {}
    local cols = {}
    local segs = {}
    local zStep = 2*radius/detail
    local iStep = 2*math.pi/detail
    table.insert(verts, {x, y, -radius})
    table.insert(cols, col1) -- interp cols
    for z=zStep-radius, radius-zStep, zStep do
        for i=0, 2*math.pi-step, iStep do
            local ang = i*iStep
            table.insert(verts, {x + radius * math.cos(ang), y + radius * math.sin(ang), z})
            table.insert(cols, col1) -- interp cols
            local vi = vertexCount + #verts - 2
            if i~=0 then table.insert(segs, {vi - 1, vi}) end
            if z ~= zStep-radius then
                table.insert(segs, {vi - detail, vi})
            else
                table.insert(segs, {vertexCount, vi})
            end
        end
    end
    table.insert(verts, {x, y, radius})
    table.insert(cols, col1) -- interp cols
    for _,o in ipairs(verts) do
        table.insert(mes.vertexes, o)
    end
    for _,o in ipairs(cols) do
        table.insert(mesh.colors, o)
    end
    for _,o in ipairs(segs) do
        table.insert(mesh.segments, o)
    end
    return mesh
end

function gfx2.recurse(outmesh, P, from, to, step, inmesh, close)
    local x,y,z = P[1],P[2],P[3]
    local verts,cols = {},{}
    local vc = #inmesh.vertexes
    for i=from,to,step do
        local seg={}
        for idx,vp in ipairs(inmesh.vertexes) do
            table.insert(verts, {x + i*vp[1], y + i*vp[2], z + i*vp[3]})
            table.insert(cols, inmesh.colors[idx])
            table.insert(seg, #outmesh.vertexes + #verts - 1)
        end
        if close then table.insert(seg, #outmesh.vertexes + #verts - vc) end
        table.insert(outmesh.segments, seg)
    end
    for i=1,#verts do
        table.insert(outmesh.vertexes, verts[i])
        table.insert(outmesh.colors, cols[i])
    end
end

-- for efficiency purposes ignores the alpha channel
function gfx2.recurseLight(outmesh, P, from, to, step, inmesh, close)
    local x,y,z = P[1],P[2],P[3]
    local verts,cols = {},{}
    local vc = #inmesh.vertexes
    for i=from,to,step do
        local C = math.abs(2*(i - from)/(to - from) - 1)
        local L = 255*(1 - C)
        local seg = {}
        for idx,vp in ipairs(inmesh.vertexes) do
            table.insert(verts, {x + i*vp[1], y + i*vp[2], z + i*vp[3]})
            local hex = inmesh.colors[idx]
            local r,g,b = hex//256^3, hex//256^2 % 256, hex//256 % 256
            table.insert(cols, ch.makeColor((C*r + L)//1, (C*g + L)//1, (C*b + L)//1, 255))
            table.insert(seg, #outmesh.vertexes + #verts - 1)
        end
        if close then table.insert(seg, #outmesh.vertexes + #verts - vc) end
        table.insert(outmesh.segments, seg)
    end
    for i=1,#verts do
        table.insert(outmesh.vertexes, verts[i])
        table.insert(outmesh.colors, cols[i])
    end
end

return gfx2