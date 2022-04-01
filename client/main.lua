local QBCore = exports['qb-core']:GetCoreObject()
local inBankZone = false
local InBank = false
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
    for k, v in pairs(Config.BankLocations) do
        RemoveBlip(blips[k])
    end
    blips = {}
end

local function openAccountScreen()
    QBCore.Functions.TriggerCallback('qb-banking:getBankingInformation', function(banking)
        if banking ~= nil then
            InBank = true
            SetNuiFocus(true, true)
            SendNUIMessage({
                status = "openbank",
                information = banking
            })
        end
    end)
end

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
    openAccountScreen()
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

CreateThread(function()
    if Config.UseTarget then
        for k, v in pairs(Config.Zones) do
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
    else
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
                    inBankZone = true
                    exports['qb-core']:DrawText(Lang:t('info.access_bank_key'),'left')
                    BankControl()
                else
                    inBankZone = false
                    BankControlPress = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end)

-- NUI

RegisterNetEvent("hidemenu", function()
    InBank = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closebank"
    })
end)

RegisterNetEvent('qb-banking:client:newCardSuccess', function(cardno, ctype)
    SendNUIMessage({
        status = "updateCard",
        number = cardno,
        cardtype = ctype
    })
end)

-- NUI Callbacks

RegisterNUICallback("NUIFocusOff", function(data, cb)
    InBank = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        status = "closebank"
    })
end)

RegisterNUICallback("createSavingsAccount", function(data, cb)
    TriggerServerEvent('qb-banking:createSavingsAccount')
end)

RegisterNUICallback("doDeposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:doQuickDeposit', data.amount)
        openAccountScreen()
    end
end)

RegisterNUICallback("doWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:doQuickWithdraw', data.amount, true)
        openAccountScreen()
    end
end)

RegisterNUICallback("doATMWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:doQuickWithdraw', data.amount, false)
        openAccountScreen()
    end
end)

RegisterNUICallback("savingsDeposit", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:savingsDeposit', data.amount)
        openAccountScreen()
    end
end)

RegisterNUICallback("requestNewCard", function(data, cb)
    TriggerServerEvent('qb-banking:createNewCard')
end)

RegisterNUICallback("savingsWithdraw", function(data, cb)
    if tonumber(data.amount) ~= nil and tonumber(data.amount) > 0 then
        TriggerServerEvent('qb-banking:savingsWithdraw', data.amount)
        openAccountScreen()
    end
end)

RegisterNUICallback("doTransfer", function(data, cb)
    if data ~= nil then
        TriggerServerEvent('qb-banking:initiateTransfer', data)
    end
end)

RegisterNUICallback("createDebitCard", function(data, cb)
    if data.pin ~= nil then
        TriggerServerEvent('qb-banking:createBankCard', data.pin)
    end
end)

RegisterNUICallback("lockCard", function(data, cb)
    TriggerServerEvent('qb-banking:toggleCard', true)
end)

RegisterNUICallback("unLockCard", function(data, cb)
    TriggerServerEvent('qb-banking:toggleCard', false)
end)

RegisterNUICallback("updatePin", function(data, cb)
    if data.pin ~= nil then
        TriggerServerEvent('qb-banking:updatePin', data.pin)
    end
end)
