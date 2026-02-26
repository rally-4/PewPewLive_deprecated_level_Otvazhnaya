-- ༼ つ ◕_◕ ༽つ

-- The code is an absolute mess

local ch = require("/dynamic/helpers/colorHelper.lua")

local sfx = require("/dynamic/sfx/sfx.lua")
local math = require("/dynamic/math.lua")
local weapon = require("/dynamic/weapon.lua")
local text = require("/dynamic/text.lua")

local Prinnus = require("/dynamic/entities/enemies/Prinnus.lua")
local VV = require("/dynamic/entities/enemies/VV.lua")

local function removePointonium()
    for _,e in ipairs(pewpew.get_all_entities()) do
        if pewpew.get_entity_type(e) == pewpew.EntityType.POINTONIUM then pewpew.entity_destroy(e) end
    end
end

-- | level setup |
local w = 2048fx
local h = 896fx
local rw = w/2fx -- reduced width
local rh = h/2fx -- reduced height
local gpc = w/4fx -- gameplay center (width)
pewpew.set_level_size(w,h)

--[[
Weapon reactivity:
- BULLET = Collision with player bullet.
- FREEZE_EXPLOSION = Collision with poleaxe (mace).
- ATOMIZE_EXPLOSION = Destruction by explosion or barrier (OOB). Lethal to enemies. Does not grant score.
- REPULSIVE_EXPLOSION = Destruction by collision with player. Lethal. Grants score.
--]]

local function mace(ship, r, type)
    local id = pewpew.new_customizable_entity(pewpew.entity_get_position(ship))
    pewpew.customizable_entity_set_mesh(id, "/dynamic/ship/RAKEE.lua", type)
    if type == 0 then
        pewpew.customizable_entity_set_mesh_scale(id, 2fx)
        pewpew.entity_set_radius(id, 32fx)
    else
        pewpew.customizable_entity_set_mesh_scale(id, 2fx)
        pewpew.entity_set_radius(id, 32fx)
    end
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_set_angle_interpolation(id, true)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(id)
    -- pewpew.customizable_entity_start_spawning(id, 30)
    local ang = 0fx
    local dst = 64fx
    pewpew.entity_set_update_callback(id,function(id)
        if not pewpew.get_player_configuration(0).has_lost then
            local px,py = pewpew.entity_get_position(ship)
            local my,mx = fmath.sincos(ang)
            local x = px + dst*mx
            local y = py + dst*my
            pewpew.entity_set_position(id, x, y)
            pewpew.customizable_entity_set_mesh_angle(id, ang, 0fx, 0fx, 1fx)
            
            local _,_,sa,sd = pewpew.get_player_inputs(0)
            if sd ~= 0fx then
                if type == 0 then
                    ang = sa
                    dst = sd * (r - 64fx) + 64fx
                else
                    ang = ang + (1fx - dst/r) * math.fpi/30fx
                    dst = (1fx - sd) * (r - 64fx) + 64fx
                end
            end
            
            local et = pewpew.get_entities_colliding_with_disk(x, y, 32fx)
            for _,e in ipairs(et) do
                -- local t = pewpew.customizable_entity_get_tag(e)
                pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.FREEZE_EXPLOSION, x=0fx, y=0fx, player_index=0})
            end
        end
    end)
    return id
end
local function aux(ship)
    local id = pewpew.new_customizable_entity(pewpew.entity_get_position(ship))
    pewpew.customizable_entity_set_mesh(id, "/dynamic/ship/auxiliary.lua", 0)
    pewpew.customizable_entity_set_mesh_angle(id, math.fpi/2fx, -1fx, 0fx, 0fx)
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(id)
    pewpew.customizable_entity_start_spawning(id, 15)
    pewpew.entity_set_update_callback(id,function(id)
        if not pewpew.get_player_configuration(0).has_lost then
            local ma,md = pewpew.get_player_inputs(0)
            local px,py = pewpew.entity_get_position(ship)
            local my,mx = fmath.sincos(ma)
            pewpew.customizable_entity_set_mesh_angle(id, math.fpi/2fx + md*my, -1fx, 0fx, 0fx)
            pewpew.entity_set_position(id, px, py)
        end
    end)
    return id
end

-- | player setup |
local function trail(x, y, tilt)
    local id = pewpew.new_customizable_entity(x, y)
    pewpew.customizable_entity_set_mesh(id, "/dynamic/ship/otvazhnaya_monochrome.lua", 0)
    pewpew.customizable_entity_set_mesh_angle(id, tilt, -1fx, 0fx, 0fx)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(id)
    pewpew.customizable_entity_set_mesh_color(id, 0x00ffffff)
    pewpew.customizable_entity_start_spawning(id, 0)
    local c = 255
    pewpew.entity_set_update_callback(id,function()
        c = c - 12
        if c <= 12 then pewpew.entity_destroy(id) end
        pewpew.customizable_entity_set_mesh_color(id, ch.makeColor(255 - c, c, 255, c))
    end)
end
local ship = pewpew.new_customizable_entity(gpc, rh)
pewpew.entity_set_radius(ship, 8fx)
pewpew.customizable_entity_set_mesh(ship, "/dynamic/ship/otvazhnaya.lua", 0)
pewpew.customizable_entity_set_position_interpolation(ship, true)
-- pewpew.customizable_entity_set_angle_interpolation(ship, true)
pewpew.customizable_entity_configure_wall_collision(ship, true, nil)
local dmgtilt = 0
local shipSpeed = 15fx
pewpew.entity_set_update_callback(ship, function(id)
    local ma,md = pewpew.get_player_inputs(0)
    local px,py = pewpew.entity_get_position(id)
    local my,mx = fmath.sincos(ma)
    local x = px + mx*md*shipSpeed
    local y = py + my*md*shipSpeed
    local tilt = math.fpi/2fx + md*my
    pewpew.customizable_entity_set_mesh_angle(id, tilt, -1fx, 0fx, 0fx)
    
    if md ~= 0fx then
        if x > rw then x = rw end
        trail(px, py, tilt)
        pewpew.entity_set_position(id, x, y)
    end
    pewpew.configure_player(0, {camera_x_override = px + 64fx, camera_y_override = (rh + py)/2fx})
    
    local sh = pewpew.get_player_configuration(0).shield
    local l = pewpew.get_entities_colliding_with_disk(x, y, 12fx)
    for _,e in ipairs(l) do
        local t = pewpew.customizable_entity_get_tag(e)
        pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.REPULSIVE_EXPLOSION, x=0fx, y=0fx, player_index=0})
        if e ~= ship and t > 2 then
            -- pewpew.new_floating_message(x, y, "#ff000080" .. damageText[fmath.random_int(1,#damageText)],{is_optional=true})
            sh = sh - (t >> 3)
            pewpew.configure_player(0, {shield = sh})
            dmgtilt = 30
            if sh >= 0 then
                sfx.hit()
            end
        end
    end
    dmgtilt = math.max(dmgtilt - 1, 0)
    pewpew.configure_player(0, {camera_rotation_x_axis = -fmath.to_fixedpoint(dmgtilt)/120fx})
    if sh < 0 then
        pewpew.customizable_entity_start_exploding(ship, 30)
        pewpew.entity_set_update_callback(ship, nil)
        pewpew.configure_player(0, {has_lost = true})
        sfx.playerDeath()
    end
end)
pewpew.customizable_entity_set_weapon_collision_callback(ship,function(id,player,type)
    if type == pewpew.WeaponType.ATOMIZE_EXPLOSION then
        pewpew.configure_player(0, {shield = pewpew.get_player_configuration(0).shield - 10})
        dmgtilt = 30
    end
end)
local shieldMax = 20
pewpew.configure_player(0, {shield = 20, camera_x_override = gpc, camera_y_override = rh, camera_distance = 0fx, camera_rotation_x_axis = 0fx, move_joystick_color = 0xff000080, shoot_joystick_color = 0xff000080})
local KE = mace(ship, 160fx, 0)
local E1 = undefined
local E2 = undefined

-- | background |
local outline = pewpew.new_customizable_entity(gpc, rh)
pewpew.customizable_entity_set_mesh(outline, "/dynamic/bg/outline.lua", 0)

local bg = {pewpew.new_customizable_entity(-1024fx, rh), pewpew.new_customizable_entity(1184fx, rh), pewpew.new_customizable_entity(3392fx, rh)}
for _,o in ipairs(bg) do
    pewpew.customizable_entity_set_mesh(o, "/dynamic/bg/background.lua", 0)
    pewpew.entity_set_update_callback(o, function(id)
        local x,y = pewpew.entity_get_position(id)
        if 3904fx - 32fx < x or x < 32fx - 3744fx then pewpew.customizable_entity_set_position_interpolation(o, false)
        else pewpew.customizable_entity_set_position_interpolation(o, true) end
        
        if x < -3744fx then pewpew.entity_set_position(id, x + 6624fx - 32fx, y)
        else pewpew.entity_set_position(id, x - 32fx, y) end
    end)
end

-- | cycle variables |
local day = 1
local money = 7
local onField = true

-- | box entities |
-- Types: WT (weapon type; weapon.type), RoF (base rate of fire; weapon.baseRoF) {baseRoF < 1}, Mv (movement speed; shipSpeed) {shipSpeed < 30fx}, MxSh (max shields; shieldMax) {shieldMax < 100}, EI (auxiliary firepower) {day > 15, E1 is undefined}, EII (second poleaxe) {day > 30, E1 is defined, E2 is undefined}, Cnv (convert money to score)
-- Parameters: wt (weapon type name) [string], dmv (movement speed change) [fx], ds (maximum shields change) [int], m2sc (money to score converted)
-- Cost is determined based on type and parameters
local BoxTypes = {
    {"WT", 20},
    {"RoF", 15},
    {"Mv", 15},
    {"MxSh", 15},
    {"EI", 10},
    {"EII", 10},
    {"Cnv", 15}
}
local Upgrades = {}
local function selectBoxUpgrades()
    while #Upgrades < 3 do
        local newUpgrade = BoxTypes[fmath.random_int(1, #BoxTypes)]
        if fmath.random_int(0, 100) < newUpgrade[2] then
            newUpgrade = newUpgrade[1]
            if newUpgrade == "WT" or (newUpgrade ~= Upgrades[1] and newUpgrade ~= Upgrades[2]) and (newUpgrade ~= "RoF" or weapon.baseRoF < 1) and (newUpgrade ~= "Mv" or shipSpeed < 30fx) and (newUpgrade ~= "MxSh" or shieldMax < 100) and (newUpgrade ~= "EI" or (day > 15 and E1 == undefined)) and (newUpgrade ~= "EII" or (day > 30 and E1 ~= undefined and E2 == undefined)) then
                table.insert(Upgrades, newUpgrade)
            end
        end
    end
end
local BoxEntities = {}
local function Box(x, y, utype, params)
    local id = pewpew.new_customizable_entity(x, y)
    table.insert(BoxEntities, id)
    pewpew.customizable_entity_set_tag(id, 1)
    pewpew.entity_set_radius(id, 32fx)
    local cost -- purchase cost
    local desc -- box description
    if utype == "WT" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 0)
        pewpew.customizable_entity_set_string(id, "#808080FF" .. params.wt)
        desc = "#A0A0A0FFChange weapon to " .. params.wt
        cost = 10
    elseif utype == "RoF" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 1)
        desc = "#40C0A0FFRaise your RoF by " .. params.RoF .. (params.RoF == 1 and " level" or " levels")
        cost = 2*params.RoF
    elseif utype == "Mv" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 2)
        desc = "#FF8020FFIncrease movement speed by " .. fmath.to_int(params.dmv) .. "fx"
        cost = 2*fmath.to_int(params.dmv) + 1
    elseif utype == "MxSh" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 3)
        desc = "#C0FF20FFIncrease maximum shield count by " .. params.ds
        cost = 3*params.ds//5
    elseif utype == "EI" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 4)
        desc = "#E08888FFObtain auxiliary firepower"
        cost = 25
    elseif utype == "EII" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 5)
        desc = "#6020E0FFObtain an elite poleaxe"
        cost = 50
    elseif utype == "Cnv" then
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 6)
        desc = "#FFE080FFGain " .. 500*params.m2sc .. " score"
        cost = params.m2sc
    else
        pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/BoxMeshes.lua", 7)
        pewpew.customizable_entity_set_string(id, "#802020FFN/A")
        desc = "#A04040FFContinue without upgrading"
        cost = 0
    end
    pewpew.customizable_entity_start_spawning(id, 60)
    
    local txt1 = pewpew.new_customizable_entity(x, y - 48fx)
    pewpew.customizable_entity_set_mesh_scale(txt1, 1fx/2fx)
    if cost ~= 0 then pewpew.customizable_entity_set_string(txt1, "#A0A080FFCost: " .. (money >= cost and "#F4D46CFF" or "#F46C6CFF") .. cost) end
    local txt2 = pewpew.new_customizable_entity(x, y - 64fx)
    pewpew.customizable_entity_set_mesh_scale(txt2, 1fx/2fx)
    pewpew.customizable_entity_set_string(txt2, desc)
    
    local t = 0
    pewpew.entity_set_update_callback(id,function() t = t + 1
        if t == 60 then t = false pewpew.entity_set_update_callback(id,nil) end
    end)
    
    pewpew.customizable_entity_set_weapon_collision_callback(id,function(id,player,type,dmg)
        if type == pewpew.WeaponType.ATOMIZE_EXPLOSION then
            pewpew.customizable_entity_start_exploding(id, 30)
            pewpew.customizable_entity_set_tag(id, 0)
            pewpew.customizable_entity_set_string(id, "")
            pewpew.customizable_entity_set_weapon_collision_callback(id, nil)
            pewpew.entity_destroy(txt1)
            pewpew.entity_destroy(txt2)
        elseif type == pewpew.WeaponType.REPULSIVE_EXPLOSION and (money >= cost or utype == "None") and not t then
            if utype == "WT" then
                if params.wt == "RF" then weapon.piercing = 1 elseif
                    params.wt == "AMRF" then weapon.piercing = 3 else weapon.piercing = 0 end
                weapon.durability = 9
                weapon.type = weapon.types[params.wt]
            elseif utype == "RoF" then
                weapon.baseRoF = weapon.baseRoF + params.RoF/27
            elseif utype == "Mv" then
                shipSleed = shipSpeed + params.dmv
            elseif utype == "MxSh" then
                shieldMax = shieldMax + params.ds
                pewpew.configure_player(0, {shield = shieldMax})
            elseif utype == "EI" then
                E1 = aux(ship)
            elseif utype == "EII" then
                E2 = mace(ship, 160fx, 0)
            elseif utype == "Cnv" then
                pewpew.increase_score_of_player(0, 500*params.m2sc)
            end
            if utype ~= "None" then sfx.bonus() end
            money = money - cost
            local str = "Day " .. day .. ", " .. (money >= 0 and "#F4D46CFF" or "#F46C6CFF") .. "ø: " .. money
            pewpew.configure_player_hud(0, {top_left_line = str})
            
            for _,e in ipairs(BoxEntities) do
                pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.ATOMIZE_EXPLOSION, x=0fx, y=0fx, player_index=0})
            end
            BoxEntities = {}
            text.remove()
            onField = true
            pewpew.customizable_entity_start_exploding(id, 30)
            pewpew.customizable_entity_set_tag(id, 0)
            pewpew.customizable_entity_set_string(id, "")
            pewpew.customizable_entity_set_weapon_collision_callback(id, nil)
            pewpew.entity_destroy(txt1)
            pewpew.entity_destroy(txt2)
        end
    end)
end

-- | waves management |
wave = {}

--[[
Enemies:
Prinnus - Average. Charges forward, halts only when afront the player. [`The standard autonomous mech issued by WAS Productions of Vekozmia. Far more cost-efficient than any manned ship, but somewhat lacking in destructive power.`]
VV - Kamikaze exploder. Rushes forth and explodes upon collision with player (small atomize explosion). [`A kamikaze automaton named after the pyrotechnician of Task Force RALLY. Despite the simple appearance, its destructive power is not to be taken lightly.`]
Aphyx - Translucent. Slowly moves forth while becoming less and less transparent. Tanky. [`The perfect unit for stealth missions, named after the EW expert of Task Force RALLY. Its resilience is outstanding, making it hard to counter unless spotted quickly.`]
Tensor - Sniper. Slowest enemy, moves forward up to a point and then stops. [`One shot, one kill. That's the selling point of this solitary WAS mech, named after the marksman of Task Force RALLY. It can prove lethal if not eliminated quickly.`]
Naraxa - ???
ReVe - Miniboss. Elusive. Avoids the player's range of attack while remaining close. Has its own mace (vanilla). [`A mech that will not go gentle into that good night, named after the leader and CQC elite of Task Force RALLY. Finally, a worthy opponent... our battle will be legendary!`]
Otvazhnaya - Boss. [`The ultimate form of the ultimate form. Created by Regen, an outstanding researcher and WAS Productions employee, known for her former association with Rally Four and faked death circa 11.C250.`]
--]]
wave.enemyList = {
    "Prinnus",
    "VV",
    "Aphyx",
    "Tensor",
    "Naraxa",
    "ReVe",
    "Otvazhnaya"
}
wave.spawnable = {"Prinnus"}

local scorecap = 160 -- limiter for number of enemies spawned per day. Planned to be the maximum obtainable score per day, but the ideas of batchCount and sizes made it impractical
local scorequota = 160 -- counter for the spawned enemies' score
local waveInterval = 90
local enemyTypeCount = 1 -- maximum amount of enemy types in a day. Minimum is two types when possible
local batchCount = 1 -- amount of enemies spawned per batch. May not apply to all enemy types

local enemies = {}
local inadequateDefense = 0 -- number of enemies leaked in a day

-- | end-of-cycle function |
wave.day = function()
    sfx.day()
    -- | wave parameters |
    day = day + 1
    batchCount = (4 + day) // 3
    scorecap = scorecap + 80 + 5*day
    scorequota = scorecap
    waveInterval = math.min(90 + 3*day, 150)
    enemyTypeCount = math.min(1 + day // 5, 2 --[[ #wave.enemyList - 3 --]])
    
    wave.spawnable = {}
    for i = 1, enemyTypeCount do
        local e = wave.enemyList[fmath.random_int(1, math.min((7 + day) // 5, #wave.enemyList - 5))]
        if e == wave.spawnable[1] then
            i = i - 1
        else
            table.insert(wave.spawnable, e)
        end
    end
    
    -- | upgrades |
    selectBoxUpgrades()
    for i,u in ipairs(Upgrades) do
        local wt = weapon.names[fmath.random_int(2, #weapon.names)]
        local RoF = math.min(fmath.random_int(1, 3), 27 - 27*weapon.RoF//1)
        local dmv = math.min(fmath.to_fixedpoint(fmath.random_int(1, 4)), 25fx - shipSpeed)
        local ds = math.min(5*fmath.random_int(1, 2 + day // 10), 100 - shieldMax)
        local m2sc = fmath.random_int(1, 10)
        if i % 2 ~= 0 then
            Box(320fx + 128fx*fmath.to_fixedpoint(i), 384fx, u, {wt = wt, RoF = RoF, dmv = dmv, ds = ds, m2sc = m2sc})
        else
            Box(320fx + 128fx*fmath.to_fixedpoint(i), 192fx, u, {wt = wt, RoF = RoF, dmv = dmv, ds = ds, m2sc = m2sc})
        end
    end
    Upgrades = {}
    Box(320fx + 128fx*4fx, 192fx, "None", {})
end
pewpew.configure_player_hud(0, {top_left_line = "Day 1, #F4D46CFFø: 7"})

-- | seeding |
local variable_44 = fmath.random_int(0,255)
local pcol = variable_44 < 170 and 0x808c90ff or 0x78b0b0ff

-- | update callback |
local t = variable_44
local ma = 0fx
local ended = false
pewpew.add_update_callback(function()
    if ended then return 0 end
    local conf = pewpew.get_player_configuration(0)
    if conf.has_lost then
        pewpew.stop_game()
        ended = true
    end
    -- pewpew.print_debug_info()
    t = t+1
    
    -- | player variables |
    local ma_,md,sa,sd = pewpew.get_player_inputs(0)
    if md~=0fx then ma=ma_ end
    local px,py = pewpew.entity_get_position(ship)
    local sc = pewpew.get_score_of_player(0)
    
    -- | particles |
    if t%5==0 then
        local z = fmath.random_fixedpoint(-256fx, -192fx)
        local dx = fmath.random_fixedpoint(-48fx, -32fx)
        if fmath.random_int(0,1) == 1 then
            local y = fmath.random_fixedpoint(h-32, h+32fx)
            pewpew.add_particle(w, y, z, dx, 0fx, 0fx, pcol, 120)
        else
            local y = fmath.random_fixedpoint(-32fx, 32fx)
            pewpew.add_particle(w, y, z, dx, 0fx, 0fx, pcol, 120)
        end
    end
    
    if onField then
        -- | weapon handler |
        if weapon.cool < 1 then
            weapon.cool = weapon.cool + weapon.baseRoF/weapon.RoFdiv[weapon.type]
        else
            weapon.cool = weapon.cool - 1
            weapon.shoot(px, py)
            sfx.mutePew(px, py)
        end
        if E1 ~= undefined and t % 15 == 0 then
            local ang = 0fx
            weapon.spawnAltBullet(px - 14fx, py - 24fx, ang, 24fx)
            sfx.pew(px, py)
        end
        
        -- | enemies handler |
        for idx,e in ipairs(enemies) do
            if not pewpew.entity_get_is_alive(e) then
                table.remove(enemies, idx)
            elseif pewpew.customizable_entity_get_tag(e) >> 1 & 1 == 1 then
                local ex = pewpew.entity_get_position(e)
                if ex <= 1fx then
                    pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.ATOMIZE_EXPLOSION, x=0fx, y=0fx, player_index=0})
                    inadequateDefense = inadequateDefense + 1
                end
            end
        end
        
        -- | wave handler |
        if t % waveInterval == 0 and scorequota > 0 then
            local enemy = wave.spawnable[fmath.random_int(1, #wave.spawnable)]
            
            if enemy == "Prinnus" then
                for i = 1, batchCount do
                    local rx = fmath.random_fixedpoint(w - 320fx, w - 192fx)
                    local ry = fmath.random_fixedpoint(144fx, h - 144fx)
                    local accel = fmath.random_fixedpoint(1fx/10fx, 1fx/8fx)
                    local size = fmath.random_int(1, math.min(1 + day // 5, 3))
                    table.insert(enemies, Prinnus(ship, rx, ry, accel, size))
                    scorequota = scorequota - 160*size
                end
            elseif enemy == "VV" then
                for i = 1, 1 + batchCount // 2 do
                    local rx = fmath.random_fixedpoint(w - 320fx, w - 192fx)
                    local ry = fmath.random_fixedpoint(144fx, h - 144fx)
                    local size = fmath.random_int(1, math.min(1 + day // 5, 3))
                    table.insert(enemies, VV(ship, rx, ry, size))
                    scorequota = scorequota - 80*size
                end
            end
        elseif scorequota <= 0 and #enemies == 0 then
            onField = false
            
            if weapon.type ~= 1 then
                weapon.durability = weapon.durability - 1
                if weapon.durability <= 0 then
                    weapon.type = 1
                    weapon.piercing = 0
                end
            end
            local dm = text.taxes(day, variable_44, conf.shield, shieldMax, inadequateDefense, weapon.names[weapon.type], weapon.durability)
            inadequateDefense = 0
            if money < 0 and money + dm < 0 then
                -- kill player
            end
            money = money + dm
            
            local str = "Day " .. day .. ", " .. (money >= 0 and "#F4D46CFF" or "#F46C6CFF") .. "ø: " .. money
            pewpew.configure_player_hud(0, {top_left_line = str})
            pewpew.configure_player(0, {shield = shieldMax})
            
            wave.day() -- move all remaining code here?
        end
    end
    
end)