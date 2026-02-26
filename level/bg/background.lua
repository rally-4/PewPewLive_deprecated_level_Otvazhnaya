local hxc = 0x808c9040
local bg1 = 0x606c70ff
local bg2 = 0x5c6068ff

meshes={{vertexes={},colors={},segments={}}}

--[[
All bent over the x-axis (y-coord determines z in sinusodial manner)
1. Hexagon tiling
2. Lines overlay over tiling
3. Rib-like strokes (s, s, l, s, s, l, ...)
4. Light-blue net inbetween the ribs outside the tiling
--]]

local r = 96
local shift = r/2 -- same as r * cos(pi/3)
local dst = 512 -- how far into the background (z-axis) it's located
local idx = 0
for x = 0, 24*r, r+shift do
    for y = -5*r, 5*r, r do
        if x == 0 then
            table.insert(meshes[1].vertexes, {x, y - shift, -10*r * math.cos(.05*(y - shift)/r * math.pi) - dst})
            table.insert(meshes[1].colors, hxc)
            idx = idx + 1
        else
            if x % (3*r) == 0 then
                table.insert(meshes[1].vertexes, {x - shift, y - shift, -10*r * math.cos(.05*(y - shift)/r * math.pi) - dst})
                table.insert(meshes[1].vertexes, {x, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
                
                table.insert(meshes[1].colors, hxc)
                table.insert(meshes[1].colors, hxc)
                
                table.insert(meshes[1].segments, {idx, idx + 1})
                if y ~= -5*r then table.insert(meshes[1].segments, {idx - 1, idx}) end
                table.insert(meshes[1].segments, {idx - 22, idx})
                
                idx = idx + 2
            else
                table.insert(meshes[1].vertexes, {x, y - shift, -10*r * math.cos(.05*(y - shift)/r * math.pi) - dst})
                table.insert(meshes[1].vertexes, {x - shift, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
                
                table.insert(meshes[1].colors, hxc)
                table.insert(meshes[1].colors, hxc)
                
                table.insert(meshes[1].segments, {idx, idx + 1})
                if y ~= -5*r then table.insert(meshes[1].segments, {idx - 1, idx}) end
                if x ~= r+shift then table.insert(meshes[1].segments, {idx - 21, idx + 1}) end
                
                idx = idx + 2
            end
        end
    end
end

table.insert(meshes[1].vertexes, {r, -5*r-shift, -10*r * math.cos(.05*(-5*r-shift)/r * math.pi) - dst})
table.insert(meshes[1].vertexes, {24*r, -5*r-shift, -10*r * math.cos(.05*(-5*r-shift)/r * math.pi) - dst})
table.insert(meshes[1].vertexes, {r, 5*r, -10*r * math.cos(.25 * math.pi) - dst})
table.insert(meshes[1].vertexes, {24*r, 5*r, -10*r * math.cos(.25* math.pi) - dst})
table.insert(meshes[1].colors, bg2)
table.insert(meshes[1].colors, bg2)
table.insert(meshes[1].colors, bg2)
table.insert(meshes[1].colors, bg2)
table.insert(meshes[1].segments, {idx, idx + 1})
table.insert(meshes[1].segments, {idx + 2, idx + 3})
idx = idx + 4

--[[
local i = 1
local height = 2.418367347 * 2 -- * math.sqrt(10*r * math.cos(.25 * math.pi) + dst)
for y = -5*r-shift, 5*r, height do
    local z = -10*r * math.cos(.05*y/r * math.pi) - dst
    table.insert(meshes[1].vertexes, {0, y, z})
    table.insert(meshes[1].vertexes, {24*r, y, z})
    if true then
        table.insert(meshes[1].colors, bg1)
        table.insert(meshes[1].colors, bg1)
    else
        table.insert(meshes[1].colors, bg2)
        table.insert(meshes[1].colors, bg2)
    end
    table.insert(meshes[1].segments, {idx, idx + 1})
    idx = idx + 2
    i = -i
end
--]]

for xs = 0, 2.418367347 * 2.01, 2.418367347 do
    for y = -6*r-shift, 6*r, shift do
        table.insert(meshes[1].vertexes, {8*r - xs, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].vertexes, {16*r - xs, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].vertexes, {24*r - xs, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].colors, bg2)
        table.insert(meshes[1].colors, bg2)
        table.insert(meshes[1].colors, bg1)
        if y ~= -6*r-shift then
            table.insert(meshes[1].segments, {idx - 3, idx})
            table.insert(meshes[1].segments, {idx - 2, idx + 1})
            table.insert(meshes[1].segments, {idx - 1, idx + 2})
        end
        idx = idx + 3
    end
end
for y = -7*r, 6*r+shift, shift do
    if 5*r+shift < y or y < -6*r then
        table.insert(meshes[1].vertexes, {24*r, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].vertexes, {24*r - 2.418367347, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].vertexes, {24*r - 2.418367347 * 2, y, -10*r * math.cos(.05*y/r * math.pi) - dst})
        table.insert(meshes[1].colors, bg2)
        table.insert(meshes[1].colors, 0x60c4b0ff)
        table.insert(meshes[1].colors, bg2)
        if y ~= -7*r and y ~= 6*r then
            table.insert(meshes[1].segments, {idx - 3, idx})
            table.insert(meshes[1].segments, {idx - 2, idx + 1})
            table.insert(meshes[1].segments, {idx - 1, idx + 2})
        end
        idx = idx + 3
    end
end

for _,e in ipairs(meshes[1].vertexes) do
    --[[
    I thought it'd need to be shifted upwards by `shift/2` in order to be centrally aligned (vertically),
    but for some reason which I don't have the time to dwell into, shifting it by `shift * cos(2pi/7)`
    is the necessary value... or maybe not, but either way it's close enough to visually appear to be so.
    --]]
    e[2] = e[2] + shift * .6234898018587336
end