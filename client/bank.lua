local QBCore = exports['qb-core']:GetCoreObject()
local blips = {}

-- Functions

local function createBlips()
    for k, v in pairs(Config.BankLocations) do
        blips[k] = AddBlipForCoord(tonumber(v.x), tonumber(v.y), tonumber(v.z))
        SetBlipSprite(blips[k], Config.Blip.blipType)
        SetBlipDisplay(blips[k], 4)
        SetBlipScale  (blips[k], Config.Blip.blipScale)
        SetBlipColour (blips[k], Config.Blip.blipColor)
        SetBlipAsShortRange(blips[k], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(Config.Blip.blipName))
        EndTextCommandSetBlipName(blips[k])
    end
end

local function removeBlips()
    for k, _ in pairs(Config.BankLocations) do
        RemoveBlip(blips[k])
    end
    blips = {}
end

local function showBank()
    QBCore.Functions.TriggerCallback('qb-banking:getBankingInformation', function(banking)
        if banking ~= nil then
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "bank",
                action = "open",
                information = banking
            })
        end
    end)
end

RegisterCommand("bank", function(source, args, rawCommand)
    showBank()
end)

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    removeBlips()
end)

RegisterNetEvent('qb-banking:transferError', function(msg)
    SendNUIMessage({
        status = "transferError",
        error = msg
    })
end)

RegisterNetEvent('qb-banking:successAlert', function(msg)
    SendNUIMessage({
        status = "successMessage",
        message = msg
    })
end)

RegisterNetEvent('qb-banking:openBankScreen', function()
    showBank()
end)

local BankControlPress = false
 local function BankControl()
    CreateThread(function()
        BankControlPress = true
        while BankControlPress do
            if IsControlPressed(0, 38) then
                exports['qb-core']:KeyPressed()
                TriggerEvent('qb-banking:openBankScreen')
            end
            Wait(0)
        end
    end)
end

local function CreateBoxZonesLegacy(zones)
    for k, v in pairs(zones) do
        exports["qb-target"]:AddBoxZone("Bank_"..k, v.position, v.length, v.width, {
            name = "Bank_"..k,
            heading = v.heading,
            minZ = v.minZ,
            maxZ = v.maxZ
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-banking:openBankScreen",
                    icon = "fas fa-university",
                    label = "Access Bank",
                }
            },
            distance = 1.5
        })
    end
end

local function CreateBoxZones(zones)
    local bankPoly = {}
    for k, v in pairs(Config.BankLocations) do
        bankPoly[#bankPoly+1] = BoxZone:Create(vector3(v.x, v.y, v.z), 1.5, 1.5, {
            heading = -20,
            name="bank"..k,
            debugPoly = false,
            minZ = v.z - 1,
            maxZ = v.z + 1,
        })
        local bankCombo = ComboZone:Create(bankPoly, {name = "bankPoly"})
        bankCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                exports['qb-core']:DrawText(Lang:t('info.access_bank_key'),'left')
                BankControl()
            else
                BankControlPress = false
                exports['qb-core']:HideText()
            end
        end)
    end
end

CreateThread(function()
    if Config.UseTarget then
        CreateBoxZonesLegacy(Config.Bank.Zones)
    else
        CreateBoxZones(Config.Bank.Zones)
    end
end)

-- NUI

local function closeNui()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "bank",
        action = "close"
    })
end

RegisterNetEvent("hidemenu", function()
    closeNui()
end)

RegisterNetEvent('qb-banking:client:newCardSuccess', function(cardno, ctype)
    SendNUIMessage({
        status = "updateCard",
        number = cardno,
        cardtype = ctype
    })
end)

-- NUI Callbacks

RegisterNUICallback("close-nui", function(_, cb)
    closeNui()
    cb("ok")
end)

RegisterNUICallback("savings/account/create", function(_, cb)
    TriggerServerEvent('qb-banking:createSavingsAccount')
    cb("ok")
end)

RegisterNUICallback("deposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:doQuickDeposit', data.amount)
        showBank()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("withdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:doQuickWithdraw', data.amount, true)
        showBank()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("savings/deposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:savingsDeposit', data.amount)
        showBank()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("savings/withdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:savingsWithdraw', data.amount)
        showBank()
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("transfer", function(data, cb)
    if data ~= nil then
        TriggerServerEvent('qb-banking:initiateTransfer', data)
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("card/create", function(data, cb)
    if data.pin ~= nil then
        TriggerServerEvent('qb-banking:createBankCard', data.pin)
        cb("ok")
    end
    cb(nil)
end)

RegisterNUICallback("card/lock", function(_, cb)
    TriggerServerEvent('qb-banking:toggleCard', true)
    cb("ok")
end)

RegisterNUICallback("card/unlock", function(_, cb)
    TriggerServerEvent('qb-banking:toggleCard', false)
    cb("ok")
end)

RegisterNUICallback("card/pin/update", function(data, cb)
    if data.pin and data.currentBankCard then
        TriggerServerEvent('qb-banking:updatePin', data.currentBankCard, data.pin)
        cb("ok")
    end
    cb(nil)
end)
