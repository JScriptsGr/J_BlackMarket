ESX = exports["es_extended"]:getSharedObject()

local discount = math.random(10, 30) / 100

local function applyDiscount(price)
    return math.floor(price * (1 - discount))
end

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
end

function spawnNPCs()
    for _, npcData in ipairs(Config.Npc) do
        loadModel(npcData.model)
        local npc = CreatePed(4, npcData.model, npcData.coords.x, npcData.coords.y, npcData.coords.z - 1.0, npcData.coords.w, false, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)

        exports.ox_target:addLocalEntity(npc, {
            {
                distance = 2.0,
                name = 'black_market',
                icon = 'fa-solid fa-user-secret',
                description = 'Buy Some Goodies.',
                label = 'Buy',
                onSelect = function()
                    lib.notify({
                        title = 'Success',
                        description = 'Opening BlackMarket',
                        type = 'success'
                    })
                    openBlackMarketMenu()
                end
            }
        })
    end  
end 

function buyItem(item, price)
    local discountedPrice = applyDiscount(price)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    TriggerServerEvent('J_BlackMarket:buyItem', item, discountedPrice)
end

function openBlackMarketMenu()
    local options = {}

    table.insert(options, {
        title = 'Buy Pistols',
        description = 'Browse pistols for sale.',
        icon = 'gun',
        onSelect = function()
            local pistolOptions = {}
            for _, pistol in ipairs(Config.Items.pistols) do
                table.insert(pistolOptions, {
                    title = pistol.label,
                    description = pistol.description,
                    icon = 'gun',
                    onSelect = function()
                        buyItem(pistol.name, pistol.price)
                    end,
                    metadata = {
                        {label = 'Original Price', value = '$' .. pistol.price},
                        {label = 'Discounted Price', value = '$' .. applyDiscount(pistol.price)}
                    }
                })
            end
            lib.registerContext({
                id = 'pistol_menu',
                title = 'Pistol Selection',
                options = pistolOptions
            })
            lib.showContext('pistol_menu')
        end
    })

    for _, item in ipairs(Config.Items.items) do
        table.insert(options, {
            title = 'Buy ' .. item.label,
            description = item.description,
            icon = 'box',
            onSelect = function()
                buyItem(item.name, item.price)
            end,
            metadata = {
                {label = 'Original Price', value = '$' .. item.price},
                {label = 'Discounted Price', value = '$' .. applyDiscount(item.price)}
            }
        })
    end

    lib.registerContext({
        id = 'blackmarket_menu',
        title = 'Black Market',
        options = options
    })
    lib.showContext('blackmarket_menu')
end

RegisterNetEvent('J_BlackMarket:purchaseSuccess')
AddEventHandler('J_BlackMarket:purchaseSuccess', function(itemName)
    lib.notify({
        title = 'Success',
        description = 'Thanks For Buying',
        type = 'success'
    })
end)

CreateThread(function()
    Wait(1000)
    spawnNPCs()
end)