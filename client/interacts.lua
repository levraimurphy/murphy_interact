local interactions = require 'client.interactions'
local utils = require 'client.utils'
local settings = require 'shared.settings'
local playerState = LocalPlayer.state
local disableInteraction = false

-- CACHE
local SetDrawOrigin = SetDrawOrigin
local DrawSprite = DrawSprite
local ClearDrawOrigin = ClearDrawOrigin
local Wait = Wait
local IsControlJustPressed = IsControlJustPressed
local SetScriptGfxAlignParams = SetScriptGfxAlignParams
local ResetScriptGfxAlign = Citizen.InvokeNative(0xE3A3DB414A373DAB)
local IsNuiFocused = IsNuiFocused
local IsPedDeadOrDying = IsPedDeadOrDying
local IsPedCuffed = IsPedCuffed

local selected, unselected, interact, pin = settings.Textures.selected, settings.Textures.unselected, settings.Textures.interact, settings.Textures.pin

local currentSelection = 0
local currentInteraction = 0
local CurrentTarget = 0
local currentAlpha = 255

local function createOption(coords, option, id, width, showDot, alpha)
    utils.drawOption(coords, option.label, settings.Style, currentSelection == id and selected or unselected, id - 1, width, showDot, alpha)
end

local math_max = math.max
local math_min = math.min

local nearby, nearbyAmount = {}, 0
-- local function HasLineOfSight(coords)
--     local playerPed = PlayerPedId()
--     local camCoords = GetGameplayCamCoord()
--     local hit, hitCoords, hitEntity = RayCastGamePlayCamera(50) -- Augmente la distance si nécessaire

--     if hit and hitCoords then
--         local dist1 = #(coords - camCoords)
--         local dist2 = #(hitCoords - camCoords)

--         -- Si la distance du raycast est plus courte que la distance vers l'interaction, alors c'est bloqué
--         return dist2 >= dist1 - 0.5
--     end

--     return true
-- end

local function CreateInteractions()
    for i = 1, nearbyAmount do
        local interaction = nearby[i]

        if interaction then
            local coords = interaction.coords or utils.getCoordsFromInteract(interaction)
            local isPrimary = i == 1

            if isPrimary and currentInteraction ~= interaction.id then
                currentInteraction = interaction.id
                currentAlpha = 255
                currentSelection = 1

            end
            if not HasStreamedTextureDictLoaded(settings.Style) then
                    RequestStreamedTextureDict(settings.Style, true)
                    while not HasStreamedTextureDictLoaded(settings.Style) do
                        Wait(1)
                    end
                else
		    end
            if GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z) then

                local isClose = isPrimary and (interaction.curDist <= interaction.interactDst) and (not interaction.entity or interaction.ignoreLos or interaction.entity == CurrentTarget)
                if isPrimary and currentAlpha < 0 then
                    local options = interaction.options
                    local alpha = currentAlpha * -1

                    -- Citizen.InvokeNative(0xF5A2C681787E579D, 0.0, 0.0, 0.0, 0.0)
                    
                    SetDrawOrigin(coords.x, coords.y, coords.z)
                    SetScriptGfxDrawOrder(2 --[[ integer ]])
                    DrawSprite(settings.Style, interact, 0, 0, 0.0185, 0.03333333333333333, 0, 255, 255, 255, IsNightTime() and 200 or alpha)
                    SetScriptGfxDrawOrder(4)
                    -- Citizen.InvokeNative(0xE3A3DB414A373DAB)
                    Citizen.InvokeNative(0xE3A3DB414A373DAB)
                    local optionAmount = #options
                    local showDot = optionAmount > 1

                    for j = 1, optionAmount do
                        createOption(coords, options[j], j, interaction.width, showDot, alpha)
                    end

                    if currentSelection > optionAmount then
                        currentSelection = optionAmount
                    end

                    if currentSelection ~= 1 and (IsControlJustPressed(0, 0x6319DB71) or IsControlJustPressed(0, 0x62800C92)) then
                        currentSelection = currentSelection - 1
                    elseif currentSelection ~= optionAmount and (IsControlJustPressed(0, 0x05CA7C52) or IsControlJustPressed(0, 0x8BDE7443)) then
                        currentSelection = currentSelection + 1
                    end

                    if IsControlJustReleased(0, 0x41AC83D1) and isClose then
                        local option = options[currentSelection]

                        if option then
                            if option.action then
                                pcall(option.action, interaction.entity, interaction.coords, option.args, interaction.serverId)
                            elseif option.serverEvent then
                                TriggerServerEvent(option.serverEvent, option.args, interaction.serverId)
                            elseif option.event then
                                TriggerEvent(option.event, option, interaction.serverId)
                            end
                        end
                    end
                else

                    SetDrawOrigin(coords.x, coords.y, coords.z + 0.05)
                    SetScriptGfxDrawOrder(2 --[[ integer ]])
                    DrawSprite(settings.Style, pin, 0, 0, 0.010, 0.025, 0, 255, 255, 255, isPrimary and currentAlpha or 255)
                    SetScriptGfxDrawOrder(4)
                    Citizen.InvokeNative(0xE3A3DB414A373DAB)
                end

                ClearDrawOrigin()

                if isPrimary then
                    if isClose then
                        currentAlpha = math_max(-255, currentAlpha - 5)
                        if IsNightTime() then
                            currentAlpha = math_min(currentAlpha, 200) -- Limite l'opacité pour éviter le flickering
                        end
                    else
                        currentAlpha = math_min(255, currentAlpha + 5)
                    end
                end
            end
        end
    end
end
function IsNightTime()
    local hour = GetClockHours()
    return hour >= 20 or hour <= 5
end

local function isDisabled()
    if playerState.interactionsDisabled then
        return true
    end

    if settings.Disable.onDeath and (IsPedDeadOrDying(cache.ped) or playerState.isDead) then
        return true
    end

    if settings.Disable.onNuiFocus and IsNuiFocused() then
        return true
    end

    if settings.Disable.onVehicle and cache.vehicle then
        return true
    end

    if settings.Disable.onHandCuff and IsPedCuffed(cache.ped) then
        return true
    end

    return false
end

-- Fast thread
CreateThread(function ()
    lib.requestStreamedTextureDict(settings.Style)
    -- Citizen.InvokeNative(0xC1BA29DF5631B0F8, settings.Style, true)
    local showinteraction = false
    local wait = 500
    while true do


            if nearbyAmount > 0 and not disableInteraction then
                wait = 0
                if IsControlPressed(0, 0x8AAA0AD4) then
                    showinteraction = true
                else
                    showinteraction = false
                end
                if showinteraction then
                    DisableControlAction(0, 0xFD0F0C2C, true) --- 	INPUT_NEXT_WEAPON
                    DisableControlAction(0, 0xCC1075A7, true) --- 	INPUT_PREV_WEAPON
                    DisableControlAction(0, 0x018C47CF, true) --- INPUT_MELEE_GRAPPLE_CHOKE
                    DisableControlAction(0, 0x2277FAE9, true) --- INPUT_MELEE_GRAPPLE
                    DisableControlAction(0, 0x2EAB0795, true) --- INPUT_DYNAMIC_SCENARIO

                    DisableControlAction(0, 0xCBDB82A8, true) --- 	INPUT_HORSE_EXIT
                    DisableControlAction(0, 0xFEFAB9B4, true) --- 	INPUT_VEH_EXIT
                    DisableControlAction(0, 0xCEFD9220, true) --- INPUT_ENTER
                    CreateInteractions()
                end
            else
                wait = 500
            end

        Wait(wait)
    end
end)

-- Slow checker thread
-- local getCurrentTarget = require 'client.raycast'
local threadTimer = 250 

CreateThread(function()
    while true do
        disableInteraction = isDisabled()

        if disableInteraction then
            nearby, nearbyAmount = table.wipe(nearby), 0
            CurrentTarget = 0
        else
            local hit, coords, entity = RayCastGamePlayCamera(10)
            CurrentTarget = entity or nil
        
            nearby, nearbyAmount = interactions.getNearbyInteractions()
        end

        Wait(threadTimer)
    end
end)