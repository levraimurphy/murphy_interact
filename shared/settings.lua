-- How to add a new style:
-- 1. Copu img_samplke folder and modify .png files as you wish.
-- 2. Using GIMP, export then as .dds files.
-- 3. Using Codex explorer, make a new .ytd and put in all your dds files.
-- 4. Put the .ytd in stream folder
-- 5. put the name of your .ytd below under Style and enjoy !

return {
    Debug = GetConvar('debug', 'false') == 'true' and true or false, -- Enable / Disable debug mode
    Style = 'redm_native_muziq', -- redm_native_murphy or redm_native_muziq, redm_native_murphy can make people crash for unknown reason 
    Textures = { -- Do not change
        pin = 'pin',
        interact = 'interact',
        selected = 'selected',
        unselected = 'unselected',
        select_opt = 'select_opt',
        unselect_opt = 'unselect_opt',
    },
    Disable = {
        onDeath = true, -- Disable interactions on death
        onNuiFocus = true, -- Disable interactions while NUI is focused
        onVehicle = true, -- Disable interactions while in a vehicle
        onHandCuff = true, -- Disable interactions while handcuffed
    },
}
