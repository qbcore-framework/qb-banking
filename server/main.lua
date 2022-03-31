local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local accts = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE account_type = ?', { 'Business' })
    if accts[1] ~= nil then
        for k, v in pairs(accts) do
            local acctType = v.business
            if businessAccounts[acctType] == nil then
                businessAccounts[acctType] = {}
            end
            businessAccounts[acctType][tonumber(v.businessid)] = generateBusinessAccount(tonumber(v.account_number), tonumber(v.sort_code), tonumber(v.businessid))
            while businessAccounts[acctType][tonumber(v.businessid)] == nil do Wait(0) end
        end
    end

    local savings = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE account_type = ?', { 'Savings' })
    if savings[1] ~= nil then
        for k, v in pairs(savings) do
            savingsAccounts[v.citizenid] = generateSavings(v.citizenid)
        end
    end

    local gangs = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE account_type = ?', { 'Gang' })
    if gangs[1] ~= nil then
        for k, v in pairs(gangs) do
            gangAccounts[v.gangid] = loadGangAccount(v.gangid)
        end
    end
end)

exports('business', function(acctType, bid)
    if businessAccounts[acctType] then
        if businessAccounts[acctType][tonumber(bid)] then
            return businessAccounts[acctType][tonumber(bid)]
        end
    end
end)

exports('registerAccount', function(cid)
    local _cid = tonumber(cid)
    currentAccounts[_cid] = generateCurrent(_cid)
end)

exports('current', function(cid)
    if currentAccounts[cid] then
        return currentAccounts[cid]
    end
end)

exports('debitcard', function(cardnumber)
    if bankCards[tonumber(cardnumber)] then
        return bankCards[tonumber(cardnumber)]
    else
        return false
    end
end)

exports('savings', function(cid)
    if savingsAccounts[cid] then
        return savingsAccounts[cid]
    end
end)

exports('gang', function(gid)
    if gangAccounts[gid] then
        return gangAccounts[gid]
    end
end)

RegisterNetEvent('qb-banking:createNewCard', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer ~= nil then
        local cid = xPlayer.PlayerData.citizenid
        if (cid) then
            currentAccounts[cid].generateNewCard()
        end
    end

    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'lightgreen', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")**" .. " created new card")
end)

--[[ -- Only used by the following "qb-banking:initiateTransfer"

local function getCharacterName(cid)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local name = player.PlayerData.name
end

local function checkAccountExists(acct, sc)
    local success
    local cid
    local actype
    local processed = false
    local exists = MySQL.Sync.fetchAll('SELECT * FROM bank_accounts WHERE account_number = ? AND sort_code = ?', { acct, sc })
    if exists[1] ~= nil then
        success = true
        cid = exists[1].character_id
        actype = exists[1].account_type
    else
        success = false
        cid = false
        actype = false
    end
    processed = true
    repeat Wait(0) until processed == true
    return success, cid, actype
end

]]

RegisterNetEvent('qb-banking:initiateTransfer', function(data)
    --[[
    local _src = source
    local _startChar = QBCore.Functions.GetPlayer(_src)
    while _startChar == nil do Wait(0) end

    local checkAccount, cid, acType = checkAccountExists(data.account, data.sortcode)
    while checkAccount == nil do Wait(0) end

    if (checkAccount) then
        local receiptName = getCharacterName(cid)
        while receiptName == nil do Wait(0) end

        if receiptName ~= false or receiptName ~= nil then
            local userOnline = exports.qb-base:checkOnline(cid)

            if userOnline ~= false then
                -- User is online so we can do a straght transfer
                local _targetUser = exports.qb-base:Source(userOnline)
                if acType == "Current" then
                    local targetBank = _targetUser:Bank().Add(data.amount, 'Bank Transfer from '.._startChar.GetName())
                    while targetBank == nil do Wait(0) end
                    local bank = _startChar:Bank().Remove(data.amount, 'Bank Transfer to '..receiptName)
                    TriggerClientEvent('pw:notification:SendAlert', _src, {type = "inform", text = "You have sent a bank transfer to "..receiptName..' for the amount of $'..data.amount, length = 5000})
                    TriggerClientEvent('pw:notification:SendAlert', userOnline, {type = "inform", text = "You have received a bank transfer from ".._startChar.GetName()..' for the amount of $'..data.amount, length = 5000})
                    TriggerClientEvent('qb-banking:openBankScreen', _src)
                    TriggerClientEvent('qb-banking:successAlert', _src, 'You have sent a bank transfer to '..receiptName..' for the amount of $'..data.amount)
                else
                    local targetBank = savingsAccounts[cid].AddMoney(data.amount, 'Bank Transfer from '.._startChar.GetName())
                    while targetBank == nil do Wait(0) end
                    local bank = _startChar:Bank().Remove(data.amount, 'Bank Transfer to '..receiptName)
                    TriggerClientEvent('pw:notification:SendAlert', _src, {type = "inform", text = "You have sent a bank transfer to "..receiptName..' for the amount of $'..data.amount, length = 5000})
                    TriggerClientEvent('pw:notification:SendAlert', userOnline, {type = "inform", text = "You have received a bank transfer from ".._startChar.GetName()..' for the amount of $'..data.amount, length = 5000})
                    TriggerClientEvent('qb-banking:openBankScreen', _src)
                    TriggerClientEvent('qb-banking:successAlert', _src, 'You have sent a bank transfer to '..receiptName..' for the amount of $'..data.amount)
                end

            else
                -- User is not online so we need to manually adjust thier bank balance.
                    MySQL.Async.fetchScalar("SELECT `amount` FROM `bank_accounts` WHERE `account_number` = @an AND `sort_code` = @sc AND `character_id` = @cid", {
                        ['@an'] = data.account,
                        ['@sc'] = data.sortcode,
                        ['@cid'] = cid
                    }, function(currentBalance)
                        if currentBalance ~= nil then
                            local newBalance = currentBalance + data.amount
                            if newBalance ~= currentBalance then
                                MySQL.Async.execute("UPDATE `bank_accounts` SET `amount` = @newBalance WHERE `account_number` = @an AND `sort_code` = @sc AND `character_id` = @cid", {
                                    ['@an'] = data.account,
                                    ['@sc'] = data.sortcode,
                                    ['@cid'] = cid,
                                    ['@newBalance'] = newBalance
                                }, function(rowsChanged)
                                    if rowsChanged == 1 then
                                        local time = os.date("%Y-%m-%d %H:%M:%S")
                                        MySQL.Async.insert("INSERT INTO `bank_statements` (`account`, `character_id`, `account_number`, `sort_code`, `deposited`, `withdraw`, `balance`, `date`, `type`) VALUES (@accountty, @cid, @account, @sortcode, @deposited, @withdraw, @balance, @date, @type)", {
                                            ['@accountty'] = acType,
                                            ['@cid'] = cid,
                                            ['@account'] = data.account,
                                            ['@sortcode'] = data.sortcode,
                                            ['@deposited'] = data.amount,
                                            ['@withdraw'] = nil,
                                            ['@balance'] = newBalance,
                                            ['@date'] = time,
                                            ['@type'] = 'Bank Transfer from '.._startChar.GetName()
                                        }, function(statementUpdated)
                                            if statementUpdated > 0 then
                                                local bank = _startChar:Bank().Remove(data.amount, 'Bank Transfer to '..receiptName)
                                                TriggerClientEvent('pw:notification:SendAlert', _src, {type = "inform", text = "You have sent a bank transfer to "..receiptName..' for the amount of $'..data.amount, length = 5000})
                                                TriggerClientEvent('qb-banking:openBankScreen', _src)
                                                TriggerClientEvent('qb-banking:successAlert', _src, 'You have sent a bank transfer to '..receiptName..' for the amount of $'..data.amount)
                                            end
                                        end)
                                    end
                                end)
                            end
                        end
                    end)
            end
        end
    else
        -- Send error to client that account details do no exist.
        TriggerClientEvent('qb-banking:transferError', _src, 'The account details entered could not be located.')
    end
]]
end)

local function format_int(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

QBCore.Functions.CreateCallback('qb-banking:getBankingInformation', function(source, cb)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    while xPlayer == nil do Wait(0) end
        if (xPlayer) then
            local banking = {
                    ['name'] = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname,
                    ['bankbalance'] = '$'.. format_int(xPlayer.PlayerData.money['bank']),
                    ['cash'] = '$'.. format_int(xPlayer.PlayerData.money['cash']),
                    ['accountinfo'] = xPlayer.PlayerData.charinfo.account,
                }
                if savingsAccounts[xPlayer.PlayerData.citizenid] then
                    local cid = xPlayer.PlayerData.citizenid
                    banking['savings'] = {
                        ['amount'] = savingsAccounts[cid].GetBalance(),
                        ['details'] = savingsAccounts[cid].getAccount(),
                        ['statement'] = savingsAccounts[cid].getStatement(),
                    }
                end
                cb(banking)
        else
            cb(nil)
        end
end)

RegisterNetEvent('qb-banking:createBankCard', function(pin)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local cid = xPlayer.PlayerData.citizenid
    local cardNumber = math.random(1000000000000000,9999999999999999)
    xPlayer.Functions.SetCreditCard(cardNumber)
    local info = {}
    local selectedCard = Config.cardTypes[math.random(1,#Config.cardTypes)]
    info.citizenid = cid
    info.name = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    info.cardNumber = cardNumber
    info.cardPin = tonumber(pin)
    info.cardActive = true
    info.cardType = selectedCard

    if selectedCard == "visa" then
        xPlayer.Functions.AddItem('visa', 1, nil, info)
    elseif selectedCard == "mastercard" then
        xPlayer.Functions.AddItem('mastercard', 1, nil, info)
    end

    TriggerClientEvent('qb-banking:openBankScreen', src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.debit_card'), 'success')

    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'lightgreen', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** successfully ordered a debit card")
end)

RegisterNetEvent('qb-banking:doQuickDeposit', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    while xPlayer == nil do Wait(0) end
    local currentCash = xPlayer.Functions.GetMoney('cash')

    if tonumber(amount) <= currentCash then
        local cash = xPlayer.Functions.RemoveMoney('cash', tonumber(amount), 'banking-quick-depo')
        local bank = xPlayer.Functions.AddMoney('bank', tonumber(amount), 'banking-quick-depo')
        if bank then
            TriggerClientEvent('qb-banking:openBankScreen', src)
            TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.cash_deposit', {value = amount}))
            TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'lightgreen', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** made a cash deposit of $"..amount.." successfully.")
        end
    end
end)

RegisterNetEvent('qb-banking:toggleCard', function(toggle)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    while xPlayer == nil do Wait(0) end
        --_char:Bank():ToggleDebitCard(toggle)
end)

RegisterNetEvent('qb-banking:doQuickWithdraw', function(amount, branch)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    while xPlayer == nil do Wait(0) end
    local currentCash = xPlayer.Functions.GetMoney('bank')

    if tonumber(amount) <= currentCash then
        local cash = xPlayer.Functions.RemoveMoney('bank', tonumber(amount), 'banking-quick-withdraw')
        local bank = xPlayer.Functions.AddMoney('cash', tonumber(amount), 'banking-quick-withdraw')
        if cash then
            TriggerClientEvent('qb-banking:openBankScreen', src)
            TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.cash_withdrawal', {value = amount}))
            TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'red', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** made a cash withdrawal of $"..amount.." successfully.")
        end
    end
end)

RegisterNetEvent('qb-banking:updatePin', function(pin)
    if pin ~= nil then
        local src = source
        local xPlayer = QBCore.Functions.GetPlayer(src)
        while xPlayer == nil do Wait(0) end

        --   _char:Bank().UpdateDebitCardPin(pin)
        TriggerClientEvent('qb-banking:openBankScreen', src)
        TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.updated_pin'))
    end
end)

RegisterNetEvent('qb-banking:savingsDeposit', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    while xPlayer == nil do Wait(0) end
    local currentBank = xPlayer.Functions.GetMoney('bank')

    if tonumber(amount) <= currentBank then
        local bank = xPlayer.Functions.RemoveMoney('bank', tonumber(amount))
        local savings = savingsAccounts[xPlayer.PlayerData.citizenid].AddMoney(tonumber(amount), Lang:t('info.current_to_savings'))
        while bank == nil do Wait(0) end
        while savings == nil do Wait(0) end
        TriggerClientEvent('qb-banking:openBankScreen', src)
        TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.savings_deposit', {value = tostring(amount)}))
        TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'lightgreen', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** made a savings deposit of $"..tostring(amount).." successfully..")
    end
end)

RegisterNetEvent('qb-banking:savingsWithdraw', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    while xPlayer == nil do Wait(0) end
    local currentSavings = savingsAccounts[xPlayer.PlayerData.citizenid].GetBalance()

    if tonumber(amount) <= currentSavings then
        local savings = savingsAccounts[xPlayer.PlayerData.citizenid].RemoveMoney(tonumber(amount), Lang:t('info.savings_to_current'))
        local bank = xPlayer.Functions.AddMoney('bank', tonumber(amount), 'banking-quick-withdraw')
        while bank == nil do Wait(0) end
        while savings == nil do Wait(0) end
        TriggerClientEvent('qb-banking:openBankScreen', src)
        TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.savings_withdrawal', {value = tostring(amount)}))
        TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', 'red', "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** made a savings withdrawal of $"..tostring(amount).." successfully.")
    end
end)

RegisterNetEvent('qb-banking:createSavingsAccount', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local success = createSavingsAccount(xPlayer.PlayerData.citizenid)
    repeat Wait(0) until success ~= nil
    TriggerClientEvent('qb-banking:openBankScreen', src)
    TriggerClientEvent('qb-banking:successAlert', src, Lang:t('success.opened_savings'))
    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Banking', "lightgreen", "**"..GetPlayerName(xPlayer.PlayerData.source) .. " (citizenid: "..xPlayer.PlayerData.citizenid.." | id: "..xPlayer.PlayerData.source..")** opened a savings account")
end)


QBCore.Commands.Add('givecash', Lang:t('command.givecash'), {{name = 'id', help = 'Player ID'}, {name = 'amount', help = 'Amount'}}, true, function(source, args)
    local src = source
	local id = tonumber(args[1])
	local amount = math.ceil(tonumber(args[2]))

	if id and amount then
		local xPlayer = QBCore.Functions.GetPlayer(src)
		local xReciv = QBCore.Functions.GetPlayer(id)

		if xReciv and xPlayer then
			if not xPlayer.PlayerData.metadata["isdead"] then
				local distance = xPlayer.PlayerData.metadata["inlaststand"] and 3.0 or 10.0
				if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(id))) < distance then
                    if amount > 0 then
                        if xPlayer.Functions.RemoveMoney('cash', amount) then
                            if xReciv.Functions.AddMoney('cash', amount) then
                                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.give_cash',{id = tostring(id), cash = tostring(amount)}), "success")
                                TriggerClientEvent('QBCore:Notify', id, Lang:t('success.received_cash',{id = tostring(src), cash = tostring(amount)}), "success")
                                TriggerClientEvent("payanimation", src)
                            else
                                -- Return player cash
                                xPlayer.Functions.AddMoney('cash', amount)
                                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_give'), "error")
                            end
                        else
                            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough'), "error")
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.invalid_amount'), "error")
                    end
				else
					TriggerClientEvent('QBCore:Notify', src, Lang:t('error.too_far_away'), "error")
				end
			else
				TriggerClientEvent('QBCore:Notify', src, Lang:t('error.dead'), "error")
			end
		else
			TriggerClientEvent('QBCore:Notify', src, Lang:t('error.wrong_id'), "error")
		end
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.givecash'), "error")
	end
end)

RegisterNetEvent("payanimation", function()
    TriggerEvent('animations:client:EmoteCommandStart', {"id"})
end)