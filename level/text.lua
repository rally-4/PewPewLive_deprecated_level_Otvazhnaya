local text = {}

text.tab = 24fx
text.entities = {}
function text.column(cw, th, obj)
    for i=1,#obj do
        local id=pewpew.new_customizable_entity(cw,th+(1-i)*text.tab)
        pewpew.customizable_entity_set_mesh_scale(id,3fx/4fx)
        pewpew.customizable_entity_set_string(id,obj[i])
        table.insert(text.entities,id)
    end
end
function text.remove()
    for _,e in ipairs(text.entities) do
        pewpew.entity_destroy(e)
    end
    text.entities = {}
end

local function split(str, n)
    local col = string.sub(str, 1, 9)
    str = str:gsub("#........", "")
    local len = 0
    local space = false
    local splitSps = {0}
    for i=1,#str do
        local v = string.byte(str, i)
        if v == 32 then
            len = len + 10
            if len > n or space then
                len = 0
                table.insert(splitSps, i)
            end
            space = true
        elseif 64 < v and v < 91 then
            len = len + 12
            space = false
        elseif (47 < v and v < 58) or (96 < v and v < 123) then
            len = len + 15
            space = false
        else
            len = len + 5
            space = false
        end
    end
    local strs = {}
    for i,v in ipairs(splitSps) do
        if v~=0 then v=v+1 end
        table.insert(strs, col .. string.sub(str, v, splitSps[i+1]))
    end
    return strs
end

--[[
Salary:
- Base Salary (39++) {17++, day >= 31: 44, day >= 91: 40 & no other sources of income or deduction}
- Fixed Overtime Allowance (2)*
- Commuting Allowance (1)*
- Performance Bonus {Day 34}

Deductions:
- Repair Costs (1 per shield)
- Inadequate Defense (1 per enemy)
- Health Insurance (4) {2, day >= 16: 4}
- Pension (5) {2, day >= 16: 5}
- Unemployment Insurance (3) {1, day >= 16: 3}
- Income Tax (3) {2, day >= 16: 3}
- Reconstruction Tax (1)
- Nursing Care Insurance (1)
- Loan Payment (1)
- Corporate Housing Fee (6)
- Residence Tax (9) {Day 5}
- Broadcast Reception Fee (2) {Day 10}
- Labo(u)r Shortage Tax (4) [Day 5* onwards] {Day 20}
- Consumption Tax (2) [Day 15* onwards]
- Advance Tax Payment (2) [Day 25 onwards] | I thought about calling it "Tax Payment Advanced" instead, but that kinda renders it meaningless 

*: Depends on variable_44
Note: Higher values of variable_44 result in a greater long-term income
--]]

function text.taxes(day, v44, sh, shmx, leaked, weaponType, weaponDurability)
    local dgr = "#487848FF"
    local grn = "#8CA47CFF"
    local yel = "#F4D46CFF"
    local red = "#902424FF"
    local pur = "#802460FF"
    
    local lst = "#9C8878FF"
    
    local dm = day <= 11 and 39 + day or 50
    local Salary = {
        dgr .. "SALARY",
        dgr .. "---------",
        grn .. "Base Salary (" .. (day <= 11 and 39 + day or 50) .. ")"
    }
    if v44 == 77 and day == 7 then Salary[1] = dgr .. "STONKS" end
    if v44 >= 128 then
        table.insert(Salary, grn .. "Fixed Overtime Allowance (2)")
        dm = dm + 2
        if v44 >= 192 then
            table.insert(Salary, grn .. "Commuting Allowance (1)")
            dm = dm + 1
        end
    end
    
    local Deductions = {
        dgr .. "DEDUCTIONS",
        dgr .. "-------------",
        (sh == shmx and grn or (v44 < 64 and pur or red)) .. "Repair Costs (" .. shmx - sh .. ")",
        (leaked == 0 and grn or (v44 < 64 and pur or red)) .. "Inadequate Defense (" .. leaked .. ")",
        grn .. "Health Insurance (4)",
        grn .. "Pension (5)",
        grn .. "Unemployment Insurance (3)",
        grn .. "Income Tax (3)",
        grn .. "Reconstruction Tax (1)",
        grn .. "Nursing Care Insurance (1)",
        grn .. "Loan Payment (1)",
        grn .. "Corporate Housing Fee (6)",
        grn .. "Residence Tax (9)",
        grn .. "Broadcast Reception Fee (2)"
    }
    dm = dm - shmx + sh - leaked - 35
    if day >= 5 - v44//128 * 2 then
        table.insert(Deductions, grn .. "Labor Shortage Tax (4)")
        dm = dm - 4
        if day >= 15 - v44//192 * 10 then
            table.insert(Deductions, grn .. "Consumption Tax (2)")
            dm = dm - 2
            if day >= 25 then
                table.insert(Deductions, grn .. "Advance Tax Payment (2)")
                dm = dm - 2
            end
        end
    end
    
    local top = 896fx
    text.column(208fx, top, Salary)
    text.column(512fx, top, Deductions)
    if day == 5 - v44//128 * 2 then
        local title = pewpew.new_customizable_entity(960fx, top)
        pewpew.customizable_entity_set_string(title, red .. "Introduction of the Labor Shortage Tax")
        table.insert(text.entities, title)
        local ntt = split(lst .. "Vekozmia faces a dire labor shortage as the working population declines by the aftereffects of the White Flash. To combat this emerging crisis, a new tax is hereby levied upon individuals lacking substantial contributions to our great reality.   This tax applies to unmarried individuals and non-wayfarer citizens whose taxable income falls below a certain threshold.  For the glorious future of our reality, work hard and pay your taxes.", 384)
        text.column(960fx, top - 2fx*text.tab, ntt)
    elseif day == 15 - v44//192 * 10 then
        
    elseif day == 25 then
        
    end
    
    local total = pewpew.new_customizable_entity(384fx, top - 18fx*text.tab)
    pewpew.customizable_entity_set_string(total, dgr .. "Total Income: " .. yel .. dm)
    table.insert(text.entities, total)
    
    local upg = pewpew.new_customizable_entity(256fx, 384fx)
    pewpew.customizable_entity_set_string(upg, grn .. "Select an upgrade:")
    table.insert(text.entities, upg)
    
    local wpd = pewpew.new_customizable_entity(256fx, 192fx)
    pewpew.customizable_entity_set_string(wpd, grn .. "Current weapon: #A0A0A0FF" .. weaponType .. grn .. ". Durability: " .. (weaponType ~= "HG" and ((weaponDurability > 1 and yel or red) .. weaponDurability) or "#C0C0C0FFInf") .. grn .. ".")
    pewpew.customizable_entity_set_mesh_scale(wpd, 2fx/3fx)
    table.insert(text.entities, wpd)
    
    return dm
end
return text