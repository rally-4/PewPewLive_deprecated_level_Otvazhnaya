local ch={}
function ch.makeColor(r,g,b,a)
    local col=r*256+g
    col=col*256+b
    col=col*256+a
    return col
end
function ch.changeAlpha(col,a)
    col=col-col%256+a
    return col
end
function ch.fmakeColor(r,g,b,a)
    local col=fmath.to_int(r)*256+fmath.to_int(g)
    col=col*256+fmath.to_int(b)
    col=col*256+fmath.to_int(a)
    return col
end
function ch.colorToString(col)
    local s=string.format("%x",col)
    while string.len(s)<8 do s="0"..s end
    return "#"..s
end
function ch.hexnum2rgb(hex)
    return {(hex >> 24) & 0xff, (hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff}
end
function ch.colMix(rgba1, rgba2, v)
    local iv = 1 - v
    return {iv*rgba1[1] + v*rgba2[1], iv*rgba1[2] + v*rgba2[2], iv*rgba1[3] + v*rgba2[3], iv*rgba1[4] + v*rgba2[4]}
end
function ch.hexnum2smallrgb(hex)
    return {((hex >> 24) & 0xff) / 255, ((hex >> 16) & 0xff) / 255, ((hex >> 8) & 0xff) / 255, (hex & 0xff) / 255}
end
function ch.clamp(a,b,c) return a<b and b or a>c and c or a end -- such that this library can be fully used both in and outside meshes without conflict
function ch.hueshift(col,H)
    local r,g,b,a = col[1],col[2],col[3],col[4]
    local U = math.cos(H*math.pi/180)
    local W = math.sin(H*math.pi/180)
    local M = {U + (1 - U)/3, (1 - U)/3 - math.sqrt(1/3)*W, (1 - U)/3 + math.sqrt(1/3)*W}
    return {
        ch.clamp(r*M[1] + g*M[2] + b*M[3], 0, 1),
        ch.clamp(r*M[3] + g*M[1] + b*M[2], 0, 1),
        ch.clamp(r*M[2] + g*M[3] + b*M[1], 0, 1),
        a
    }
end
return ch