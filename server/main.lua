--[[
    Thanks to ox_target for the base of removing entity netIds
]]

local entityStates = {}

RegisterNetEvent('interact:setEntityHasOptions', function(netId)
    local entity = Entity(NetworkGetEntityFromNetworkId(netId))
    local attempt = 0
    while entity.__data == 0 and attempt < 10 do
        Wait(1000)
        entity = Entity(NetworkGetEntityFromNetworkId(netId))
        -- print("Entity not found", netId, entity.__data)
        attempt = attempt + 1
    end
    entity.state.hasInteractOptions = true
    entityStates[netId] = entity
end)

CreateThread(function()
    local arr = {}
    local num = 0

    while true do
        Wait(10000)
        for netId, entity in pairs(entityStates) do
            -- Only purge when the entity truly no longer exists.
            -- Avoid removing interactions just because state.hasInteractOptions flipped during ownership/migration.
            -- print(entity.state.hasInteractOptions)
            if not DoesEntityExist(entity.__data) then
                local newEntity = nil
                entityStates[netId] = newEntity
                num += 1
                arr[num] = netId
            end
        end

        if num > 0 then
            TriggerClientEvent('interact:removeEntity', -1, arr)
            table.wipe(arr)

            num = 0
        end
    end
end)