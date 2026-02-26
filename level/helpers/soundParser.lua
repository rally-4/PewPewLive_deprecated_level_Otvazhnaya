function split(str,pat)
    local t={} -- NOTE: use {n = 0} in Lua 5.0
    local fpat = "(.-)"..pat
    local lastEnd=1
    local s,e,cap=str:find(fpat,1)
    while s do
        if s~=1 or cap~="" then
            table.insert(t,cap)
        end
        lastEnd=e+1
        s,e,cap=str:find(fpat,lastEnd)
    end
    if lastEnd<=#str then
        cap=str:sub(lastEnd)
        table.insert(t,cap)
    end
    return t
end
function parseSound(link)
    local parts=split(link,'%%22')
    local sound={}
    for i=2,#parts,2 do
        local value=parts[i+1]:sub(4,-4)
        if parts[i]=='waveform' then
            value=parts[i+2]
        end
        if parts[i]=='amplification' then
            value=value/100.0
        end
        if value=="true" then
            value=true
        end
        if value=="false" then
            value=false
        end
        sound[parts[i]]=value
    end
    return sound
end
function EditedSound(sound,newKvs)
    local soundCopy={}
    for k,v in pairs(sound) do
        soundCopy[k]=v
    end
    for k,v in pairs(newKvs)do
        soundCopy[k]=v
    end
    return soundCopy
end