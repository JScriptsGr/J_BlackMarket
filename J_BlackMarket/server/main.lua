ESX = exports["es_extended"]:getSharedObject()



RegisterServerEvent('J_BlackMarket:buyItem')
AddEventHandler('J_BlackMarket:buyItem', function(item, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('J_BlackMarket:purchaseSuccess', source, item)
    else
        lib.notify({
          id = 'some_identifier',
          title = 'Failed',
          description = 'You dont have enough money!',
          showDuration = false,
          position = 'top',
          style = {
              backgroundColor = '#141517',
              color = '#C1C2C5',
              ['.description'] = {
                color = '#909296'
              }
          },
          icon = 'ban',
          iconColor = '#C53030'
      })
    end
end)

