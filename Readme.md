restream les texture a la main


# World Interactions
Create interaction points in the world with selectable options adapted for RedM.

# Credits
[ChatDisabled](https://github.com/Chatdisabled)

[Devyn](https://github.com/darktrovx)

[Zoo](https://github.com/FjamZoo)

[Snipe](https://github.com/pushkart2)

# Guides & Information

[Video Demo 1](https://youtu.be/dQ7Pdq1pdHQ)
[Video Demo 2](https://youtu.be/9ZLK0kl2k94)

Requires [ox_lib](https://github.com/overextended/ox_lib)

Options can trigger
```
Functions
Client Events
Server Events
```

# Options Format

```lua
 {
    label = 'Hello World!',
    canInteract = function(entity, coords, args)
        return true
    end,
    action = function(entity, coords, args)
        print(entity, coords, json.encode(args))
    end,
    serverEvent = "server:Event",
    event = "client:Event",
    args = {
        value1 = 'foo',
        [2] = 'bar',
        ['three'] = 0,
    }
 }

```

# Exports
```lua
-- Add an interaction point at a set of coords
exports.murphy_interact:AddInteraction({
    coords = vec3(0.0, 0.0, 0.0),
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    name = 'interactionName', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
         {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

exports.murphy_interact:AddLocalEntityInteraction({
    entity = entityIdHere,
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    ignoreLos = false, -- optional ignores line of sight
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

-- Add an interaction point on a networked entity
exports.murphy_interact:AddEntityInteraction({
    netId = entityNetIdHere,
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    ignoreLos = false, -- optional ignores line of sight
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})

exports.murphy_interact:AddGlobalVehicleInteraction({
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})


-- Add interaction(s) to a list of models
exports.murphy_interact:AddModelInteraction({
    model = 'modelName',
    offset = vec3(0.0, 0.0, 0.0), -- optional
    bone = 'engine', -- optional
    name = 'interactionName', -- optional
    id = 'myCoolUniqueId', -- needed for removing interactions
    distance = 8.0, -- optional
    interactDst = 1.0, -- optional
    groups = {
        ['police'] = 2, -- Jobname | Job grade
    },
    options = {
        {
            label = 'Hello World!',
            action = function(entity, coords, args)
                print(entity, coords, json.encode(args))
            end,
        },
    }
})


-- Add Interaction(s) to players

exports.murphy_interact:addGlobalPlayerInteraction({
    distance = 5.0,
    interactDst = 1.5,
    offset = vec3(0.0, 0.0, 0.0),
    id = 'interact:actionPlayer',
    options = {
        name = 'interact:actionPlayer',
        label = 'Do Action On Player',
        action = function(entity, _, _, serverId)
            print(entity, serverId)
        end,
    }
})

---@param id number : The id of the interaction to remove
-- Remove an interaction point by id.
exports.murphy_interact:RemoveInteraction(interactionID)

---@param entity number : The entity to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a local entity by id.
exports.murphy_interact:RemoveLocalEntityInteraction(entity, interactionID)

---@param netId number : The network id of the entity to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a networked entity by id.
exports.murphy_interact:RemoveModelInteraction(model, interactionID)

---@param model number : The model to remove the interaction from
---@param id number : The id of the interaction to remove
-- Remove an interaction point from a model by id.
exports.murphy_interact:RemoveEntityInteraction(netId, interactionID)

---@param id number : The id of the interaction to remove
-- Remove an interaction point by id.
exports.murphy_interact:RemoveGlobalVehicleInteraction(interactionID)

---@param id number : The id of the interaction to remove
-- Remove an player interaction by id.
exports.murphy_interact:RemoveGlobalPlayerInteraction(interactionID)
```
