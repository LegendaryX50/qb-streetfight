local bluePlayerReady = false
local redPlayerReady = false
local fight = {}

RegisterServerEvent('qb-streetfight:join')
AddEventHandler('qb-streetfight:join', function(betAmount, side)

        local _source = source
        local Player = QBCore.Functions.GetPlayer(_source)

		if side == 0 then
			bluePlayerReady = true
		else
			redPlayerReady = true
		end

        local fighter = {
            id = source,
            amount = betAmount
        }
        table.insert(fight, fighter)

        if Player.PlayerData.money.cash >= betAmount then
            Player.Functions.RemoveMoney('cash', betAmount,"fight-join")
            TriggerClientEvent('QBCore:Notify', source, 'You have joined successfully', 'primary', 3500)

            if side == 0 then
                TriggerClientEvent('qb-streetfight:playerJoined', -1, 1, source)
            else
                TriggerClientEvent('qb-streetfight:playerJoined', -1, 2, source)
            end

            if redPlayerReady and bluePlayerReady then 
                TriggerClientEvent('qb-streetfight:startFight', -1, fight)
            end

        else
            TriggerClientEvent('QBCore:Notify', source, 'You don\'t have enough money', 'error', 3500)
        end
end)

local count = 240
local actualCount = 0
function countdown(copyFight)
    for i = count, 0, -1 do
        actualCount = i
        Citizen.Wait(1000)
    end

    if copyFight == fight then
        TriggerClientEvent('qb-streetfight:fightFinished', -1, -2)
        fight = {}
        bluePlayerReady = false
        redPlayerReady = false
    end
end

RegisterServerEvent('qb-streetfight:finishFight')
AddEventHandler('qb-streetfight:finishFight', function(looser)
       TriggerClientEvent('qb-streetfight:fightFinished', -1, looser)
       fight = {}
       bluePlayerReady = false
       redPlayerReady = false
end)

RegisterServerEvent('qb-streetfight:leaveFight')
AddEventHandler('qb-streetfight:leaveFight', function(id)
       if bluePlayerReady or redPlayerReady then
            bluePlayerReady = false
            redPlayerReady = false
            fight = {}
            TriggerClientEvent('qb-streetfight:playerLeaveFight', -1, id)
       end
end)

RegisterServerEvent('qb-streetfight:pay')
AddEventHandler('qb-streetfight:pay', function(amount)
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.AddMoney("cash", amount * 2, "paid-all-bills")
end)

RegisterServerEvent('qb-streetfight:showWinner')
AddEventHandler('qb-streetfight:showWinner', function(id)
       TriggerClientEvent('qb-streetfight:winnerText', -1, id)
end)