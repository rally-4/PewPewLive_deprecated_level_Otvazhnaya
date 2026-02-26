local function HV(x, y, ang, speed, dmg)
    local id = pewpew.new_customizable_entity(x, y)
    pewpew.customizable_entity_set_tag(id, 1 << 2 | dmg << 3)
    pewpew.customizable_entity_set_mesh(id, "/dynamic/entities/bullets/HVmesh.lua", dmg - 1)
    pewpew.customizable_entity_set_mesh_angle(id, ang, 0fx, 0fx, 1fx)
    pewpew.customizable_entity_set_position_interpolation(id, true)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(id)
    pewpew.entity_set_radius(id, 3fx)
    pewpew.customizable_entity_start_spawning(id, 0)
    local t = 0
    pewpew.entity_set_update_callback(id,function()
        t = t + 1
        if t > 120 then pewpew.entity_destroy(id) end
        local x,y = pewpew.entity_get_position(id)
        local my,mx = fmath.sincos(ang)
        x = x + speed*mx
        y = y + speed*my
        pewpew.entity_set_position(id, x, y)
    end)
    pewpew.customizable_entity_configure_wall_collision(id,true,function(id) pewpew.customizable_entity_start_exploding(id,15) pewpew.customizable_entity_set_tag(id,0) pewpew.entity_set_update_callback(id,nil) end)
    pewpew.customizable_entity_set_weapon_collision_callback(id,function(id,player,type)
        if type == pewpew.WeaponType.REPULSIVE_EXPLOSION then
            pewpew.customizable_entity_start_exploding(id, 15)
            pewpew.customizable_entity_set_tag(id, 0)
            pewpew.entity_set_update_callback(id, nil)
        end
    end)
end
return HV