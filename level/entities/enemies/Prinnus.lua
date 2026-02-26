local HV = require("/dynamic/entities/bullets/HV.lua")
local sfx = require("/dynamic/sfx/sfx.lua")
local math = require("/dynamic/math.lua")
local function Prinnus(ship, x, y, accel, size)
    local fsize = fmath.to_fixedpoint(size)
    accel = accel / fsize
    local id = pewpew.new_customizable_entity(x, y)
    pewpew.customizable_entity_set_tag(id, 1 << 1 | 1+size << 3)
    pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/enemies/Pmesh.lua", 0)
    pewpew.customizable_entity_set_mesh_scale(id, (1fx + fsize)/2fx)
    -- pewpew.customizable_entity_set_mesh_angle(id, ang, 0fx, 0fx, 1fx)
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(id)
    pewpew.entity_set_radius(id, 12fx + 12fx*fsize)
    pewpew.customizable_entity_start_spawning(id, 0)
    local t = 0
    local dx = 0fx
    local hp = 10 * 2 ^ (size - 1)
    local slashed = 0
    local notSlashCol = true
    pewpew.entity_set_update_callback(id,function()
        t = t + 1
        if not pewpew.entity_get_is_alive(ship) then return 0 end
        local px,py = pewpew.entity_get_position(ship)
        x,y = pewpew.entity_get_position(id)
        
        local diff = x - px
        if 32fx < diff and diff < 320fx then
            dx = math.min(dx + accel, 0fx)
        else
            dx = math.max(dx - accel, -8fx/fsize)
        end
        
        if dx > -3fx/fsize and t % 60 == 0 then
            local ang = fmath.atan2(py - y, px - x)
            HV(x, y, ang, 10fx + 2fx*fsize, size)
        end
        
        if notSlashCol then pewpew.customizable_entity_set_mesh_color(id, 0xffffffff) else notSlashCol = true end
        pewpew.customizable_entity_add_rotation_to_mesh(id, dx * math.fpi/180fx, 1fx, 0fx, 0fx)
        pewpew.entity_set_position(id, x + dx, y)
        
        slashed = slashed - 1
    end)
    pewpew.customizable_entity_configure_wall_collision(id,false,function(id) end)
    pewpew.customizable_entity_set_weapon_collision_callback(id,function(id,player,type,dmg)
        if type == pewpew.WeaponType.BULLET then
            sfx.damage1(x, y)
            hp = hp - fmath.to_int(dmg)
            pewpew.entity_move(id, 2fx + 2fx*dmg, 0fx)
            pewpew.customizable_entity_set_mesh_color(id, 0xff0000ff)
        elseif type == pewpew.WeaponType.FREEZE_EXPLOSION then
            if slashed <= 0 then
                hp = hp - 5
                notSlashCol = false
                pewpew.customizable_entity_set_mesh_color(id, 0xff0000ff)
            end
            slashed = 2
        elseif type == pewpew.WeaponType.ATOMIZE_EXPLOSION then
            sfx.explosion1(x, y)
            pewpew.customizable_entity_start_exploding(id, 30)
            pewpew.customizable_entity_set_tag(id, 0)
            pewpew.entity_set_update_callback(id, nil)
            pewpew.customizable_entity_set_weapon_collision_callback(id, nil)
        elseif type == pewpew.WeaponType.REPULSIVE_EXPLOSION then
            hp = 0
        end
        if hp <= 0 then
            sfx.explosion1(x, y)
            pewpew.increase_score_of_player(0, 160*size)
            pewpew.customizable_entity_start_exploding(id, 30)
            pewpew.customizable_entity_set_tag(id, 0)
            pewpew.entity_set_update_callback(id, nil)
            pewpew.customizable_entity_set_weapon_collision_callback(id, nil)
        end
    end)
    return id
end
return Prinnus