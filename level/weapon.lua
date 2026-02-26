local math = require("/dynamic/math.lua")

weapon = {}

weapon.baseRoF = 6/27
weapon.cool = 0
weapon.type = 1
weapon.durability = 0
-- Discarded weapon types: MP, MG, RG
weapon.names = {"HG", "SMG", "LMG", "AR", "RF", "AMRF", "SG"}
weapon.types = {
    HG = 1, -- medium RoF, medium accuracy, low damage
    SMG = 2, -- very high RoF, low accuracy, low damage
    LMG = 3, -- very high RoF, low accuracy, low damage, fires in bursts
    AR = 4, -- high RoF, medium accuracy, medium damage
    RF = 5, -- low RoF, high accuracy, high damage
    AMRF = 6, -- very low RoF, very high accuracy, very high damage, piercing
    SG = 7 -- low RoF, very low accuracy, low damage, multiple bullets per shot
}
weapon.RoFdiv = { -- very low: 16, low: 8, medium: 4, high: 2, very high: 1
    4,
    1,
    4, -- exempted
    2,
    8,
    16,
    8
}
weapon.scatter = { -- low: /16, medium: /48, high: /128, very high: /192
    math.fpi/48fx,
    math.fpi/16fx,
    math.fpi/16fx,
    math.fpi/48fx,
    math.fpi/128fx,
    math.fpi/192fx,
    math.fpi/16fx
}
weapon.bulletSpeed = {
    24fx,
    28fx,
    28fx,
    28fx,
    32fx,
    36fx,
    24fx
}
weapon.damage = { -- low: 1, medium: 2, high: 4, very high: 8
    1,
    1,
    2,
    2,
    4,
    8,
    1
}

weapon.spawnBullet = function(px, py, ang, speed, damage, piercing)
    local id = pewpew.new_customizable_entity(px, py)
    pewpew.entity_set_radius(id, 6fx)
    pewpew.customizable_entity_set_mesh(id, "/dynamic/ship/bullet.lua", damage - 1)
    pewpew.customizable_entity_set_mesh_angle(id, ang, 0fx, 0fx, 1fx)
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_start_spawning(id, 0)
    local my,mx = fmath.sincos(ang)
    mx = mx*speed
    my = my*speed
    local t = 60
    local pierceCool = 0
    pewpew.entity_set_update_callback(id, function(id)
        t = t-1
        pierceCool = pierceCool-1
        if t <= 0 then pewpew.entity_destroy(id) end
        local x,y = pewpew.entity_get_position(id)
        if pierceCool <= 0 then
            local et = pewpew.get_entities_colliding_with_disk(x, y, 4fx)
            for _,e in ipairs(et) do
                local t = pewpew.customizable_entity_get_tag(e)
                if t >> 1 & 1 == 1 then -- it's an enemy
                    pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.BULLET, x=fmath.to_fixedpoint(damage), y=0fx, player_index=0})
                    if piercing == 0 then
                        pewpew.customizable_entity_start_exploding(id, 15)
                        pewpew.entity_set_update_callback(id, nil)
                    else
                        piercing = piercing - 1
                        pierceCool = 2 -- frames of delay before it can interact with an enemy again
                    end
                end
            end
        end
        pewpew.entity_set_position(id, x + mx, y + my)
    end)
    pewpew.customizable_entity_configure_wall_collision(id, false, function(id,nx,ny)
        pewpew.customizable_entity_start_exploding(id, 15)
        pewpew.entity_set_update_callback(id, nil)
    end)
end
weapon.spawnAltBullet = function(px, py, ang, speed)
    local id = pewpew.new_customizable_entity(px, py)
    pewpew.entity_set_radius(id, 6fx)
    pewpew.customizable_entity_set_mesh(id, "/dynamic/ship/bulletAlt.lua", 0)
    pewpew.customizable_entity_set_mesh_angle(id, ang, 0fx, 0fx, 1fx)
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_start_spawning(id, 0)
    local my,mx = fmath.sincos(ang)
    mx = mx*speed
    my = my*speed
    local t = 60
    local pierceCool = 0
    pewpew.entity_set_update_callback(id, function(id)
        t = t-1
        pierceCool = pierceCool-1
        if t <= 0 then pewpew.entity_destroy(id) end
        local x,y = pewpew.entity_get_position(id)
        if pierceCool <= 0 then
            local et = pewpew.get_entities_colliding_with_disk(x, y, 4fx)
            for _,e in ipairs(et) do
                local t = pewpew.customizable_entity_get_tag(e)
                if t >> 1 & 1 == 1 then
                    pewpew.entity_react_to_weapon(e, {type=pewpew.WeaponType.BULLET, x=1fx/2fx, y=0fx, player_index=0})
                    pierceCool = 2
                end
            end
        end
        pewpew.entity_set_position(id, x + mx, y + my)
    end)
    pewpew.customizable_entity_configure_wall_collision(id, false, function(id,nx,ny)
        pewpew.customizable_entity_start_exploding(id, 15)
        pewpew.entity_set_update_callback(id, nil)
    end)
end

weapon.shotCount = 1 -- Variable for the burst mechanic
weapon.piercing = 0 -- Number of times a bullet can affect an enemy. Changes upon weapon swap (box collect)

weapon.shoot = function(px, py)
    local ang = fmath.random_fixedpoint(-weapon.scatter[weapon.type], weapon.scatter[weapon.type])
    if weapon.type == weapon.types.LMG then
        weapon.spawnBullet(px, py, ang, 28fx, 2, 0)
        if weapon.shotCount < 4 then
            weapon.shotCount = weapon.shotCount + 1
            weapon.cool = 1 - 1/18
        else
            weapon.shotCount = 1
        end
    elseif weapon.type == weapon.types.SG then
        for c = 1, 6 do
            ang = fmath.random_fixedpoint(-weapon.scatter[7], weapon.scatter[7])
            weapon.spawnBullet(px, py, ang, 24fx + fmath.random_fixedpoint(-1fx, 1fx), 1, 0)
        end
    else -- others
        weapon.spawnBullet(px, py, ang, weapon.bulletSpeed[weapon.type], weapon.damage[weapon.type], weapon.piercing)
    end
end

return weapon