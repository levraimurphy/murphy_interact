-- How to add a new style:
-- 1. Copu img_samplke folder and modify .png files as you wish.
-- 2. Using GIMP or Paint.net, export then as .dds files.
--     There are different formattings for dds files. People say for redm and gta its dxt5 but thats wrong its dxt10
--     So you need to save and choose the format dxt10 when exporting .dds files
-- 3. Using Codex explorer, make a new .ytd and put in all your dds files.
-- 4. Put the .ytd in stream folder
-- 5. put the name of your .ytd below under Style and enjoy !



return {
    keybind = 0x8AAA0AD4, --- ALT
    Debug = GetConvar('debug', 'false') == 'true' and true or false, -- Enable / Disable debug mode
    Style = 'redm_native_murphy', -- redm_native_murphy or redm_native_muziq
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
