local sfx={}
function sfx.shield() pewpew.plat_ambient_sound("/dynamic/sfx/sounds.lua",0) end
function sfx.bonus() pewpew.play_ambient_sound("/dynamic/sfx/sounds.lua",1) end
function sfx.hit() pewpew.play_ambient_sound("/dynamic/sfx/sounds.lua",2) end
function sfx.playerDeath() pewpew.play_ambient_sound("/dynamic/sfx/sounds.lua",3) end

function sfx.pew(x,y) pewpew.play_sound("/dynamic/sfx/sounds.lua",4,x,y) end

function sfx.day() pewpew.play_ambient_sound("/dynamic/sfx/sounds.lua",5) end
function sfx.damage1(x, y) pewpew.play_sound("/dynamic/sfx/sounds.lua",6,x,y) end
function sfx.damage2(x, y) pewpew.play_sound("/dynamic/sfx/sounds.lua",7,x,y) end
function sfx.explosion1(x, y) pewpew.play_sound("/dynamic/sfx/sounds.lua",8,x,y) end
function sfx.mutePew(x, y) pewpew.play_sound("/dynamic/sfx/sounds.lua",9,x,y) end

return sfx