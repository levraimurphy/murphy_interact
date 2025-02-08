function getForwardVector(rotation)
    local rot = (math.pi / 180.0) * rotation

    return vec3(-math.sin(rot.z) * math.abs(math.cos(rot.x)), math.cos(rot.z) * math.abs(math.cos(rot.x)), math.sin(rot.x))
end

function rayCast(origin, target, options, ignoreEntity, radius)
    local handle = StartShapeTestSweptSphere(origin.x, origin.y, origin.z, target.x, target.y, target.z, radius, options, ignoreEntity, 0)

    return GetShapeTestResult(handle)
end

function entityInFrontOfPlayer(distance, radius, ignoreEntity)
    local originCoords = GetPedBoneCoords(cache.ped, 21030, 0, 0, 0)
    local forwardVectors = getForwardVector(GetGameplayCamRot(2))
    local forwardCoords = originCoords + (forwardVectors * (distance or 3.0))

    if not forwardVectors then return end

    local _, hit, _, _, targetEntity = rayCast(originCoords, forwardCoords, -1, ignoreEntity, radius or 0.2)
    if not hit and targetEntity == 0 then return end

    local entityType = GetEntityType(targetEntity)
    return targetEntity, entityType
end

function getCurrentTarget()
    local entity, entityType
    pcall(function()
        entity, entityType = entityInFrontOfPlayer(3.0, 0.7, cache.ped)
    end)

    return entity and entityType ~= 0 and entity or nil
end


RayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, hit, coords, d, entity = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    if #(coords - GetEntityCoords(PlayerPedId())) < distance + 0.0 then
        return hit, coords, entity
    else
        return 0, vector3(0, 0, 0), 0
    end
end

RotationToDirection = function(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end
