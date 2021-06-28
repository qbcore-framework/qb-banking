function generateCurrent(cid)
    local self = {}
    self.cid = cid
    self.source = -1
    local processed = false

    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_cards` WHERE `citizenid` = '" .. self.cid .."'", function(getCurrentAccount)
        if getCurrentAccount[1] ~= nil then
            self.aid = getCurrentAccount[1].record_id
            self.balance = getCurrentAccount[1].amount
            if getCurrentAccount[1].cardActive then
                self.cardNumber = getCurrentAccount[1].cardNumber
                self.cardActive = getCurrentAccount[1].cardActive
                self.cardPin    = getCurrentAccount[1].cardPin
                self.cardLocked = getCurrentAccount[1].cardLocked
                self.cardDecrypted = getCurrentAccount[1].cardDecrypted
                self.cardType = getCurrentAccount[1].cardType
                bankCards[tonumber(self.cardNumber)] = { ['pin'] = self.cardPin, ['cid'] = self.cid, ['locked'] = self.cardLocked, ['active'] = self.cardActive, ['decrypted'] = self.cardDecrypted }
            else
                self.cardNumber = 0
                self.cardActive = false
                self.cardPin    = 0
                self.cardLocked = true
            end
        end
        processed = true
    end)

    repeat Wait(0) until processed == true
    processed = false

    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_statements` WHERE `account` = 'Current' AND `citizenid` = '" .. self.cid .. "' ORDER BY `record_id` DESC LIMIT 30", function(bankStatement)
        if bankStatement[1] ~= nil then
            self.bankStatement = bankStatement
        else
            self.bankStatement = {}
        end
        processed = true
    end)
    repeat Wait(0) until processed == true
    processed = false

    self.updateItemPin = function(pin)
        local processed = false
        local success
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `stored_items` WHERE `metaprivate` LIKE '%\"cardnumber\":"..self.cardNumber.."%' AND `metaprivate` LIKE '%\"account\":"..self.account.."%' AND `metaprivate` LIKE '%\"sortcode\":"..self.sortcode.."%' AND `type` = 'Bankcard' LIMIT 1", function(item)
            if item[1] ~= nil then
                itemFound = true
                local decode = json.decode(item[1].metaprivate)
                decode.pin = pin
                local recode = json.encode(decode)
                exports['ghmattimysql']:execute("UPDATE `stored_items` SET `metaprivate` = @meta WHERE `record_id` = @rid", {['@meta'] = recode, ['@rid'] = item[1].record_id}, function(done)
                    if done == 1 then
                        success = true
                    else
                        success = false
                    end
                    processed = true
                end)
            else
                success = false
                processed = true
            end
        end)
        repeat Wait(0) until processed == true
        return success
    end

    self.saveAccount = function()
        local success 
        local processed = false
        exports['ghmattimysql']:execute("UPDATE `bank_accounts` SET `amount` = @amt WHERE `character_id` = @cid AND `record_id` = @rid", {['@amt'] = self.balance, ['@cid'] = self.cid, ['@rid'] = self.aid}, function(success1)
            if success1 > 0 then
                success = true
            else
                success = false
            end
            processed = true
        end)
        repeat Wait(0) until processed == true
        return success
    end

    local rTable = {}

    rTable.GetBalance = function()
        return self.balance
    end

    rTable.ToggleDebitCard = function(toggle)
        exports['ghmattimysql']:execute("UPDATE `bank_accounts` SET `cardLocked` = @toggle WHERE `character_id` = @cid AND `record_id` = @acct", {['@cid'] = self.cid, ['@acct'] = self.aid, ['@toggle'] = toggle}, function(rowsChanged)
            if rowsChanged == 1 then
                self.cardLocked = toggle
                bankCards[tonumber(self.cardNumber)].locked = self.cardLocked
            end
        end)
    end

    rTable.generateNewCard = function(pin, scc)
        -- Delete Old Card from Active Cards Table
            bankCards[tonumber(self.cardNumber)] = nil
            self.cardNumber = 0
            self.cardActive = false
            self.cardLocked = true
            self.cardDecrypted = false
            self.cardType = nil
        if not self.cardActive then
            local cardNumber = math.random(1000000000000000,9999999999999999)
            local pinSet = tonumber(pin)
            local selectedCard = scc
            local friendlyName
            if selectedCard == "visa" then
                friendlyName = "Visa"
            else
                friendlyName = "Mastercard"
            end
            exports.ghmattimysql:execute('UPDATE bank_cards SET cardnumber=@cardnumber, cardPin=@cardPin, cardDecrypted=@cardDecrypted, cardActive=@cardActive, cardLocked=@cardLocked, cardType=@cardType WHERE citizenid=@citizenid AND record_id=@record_id', {
                ['@cardnumber'] = cardNumber,
                ['@cardPin'] = pinSet,
                ['@cardDecrypted'] = false,
                ['@cardActive'] = 1,
                ['@cardLocked'] = 0,
                ['@cardType'] = friendlyName,
                ['@citizenid'] = self.cid,
                ['@record_id'] = self.aid
            }, function(rowsChanged)
                self.cardNumber = cardNumber
                self.cardActive = true
                self.cardLocked = false
                self.cardDecrypted = false
                self.cardType = friendlyName
                bankCards[tonumber(self.cardNumber)] = { ['pin'] = pinSet, ['cid'] = self.cid, ['locked'] = self.cardLocked, ['active'] = self.cardActive, ['decrypted'] = self.cardDecrypted }
                success = true
                genId = cardNumber

                if self.source ~= -1 then
                    TriggerClientEvent('qb-banking:client:newCardSuccess', self.source, cardNumber, friendlyName)
                    local xPlayer = QBCore.Functions.GetPlayer(self.source)
                    
                    if selectedCard == "visa" then
                        xPlayer.Functions.AddItem('visa', 1)
                    elseif selectedCard == "mastercard" then
                        xPlayer.Functions.AddItem('mastercard', 1)
                    end
                end
            end)
        end
    end

    rTable.GetCardStatus = function()
        return self.cardActive
    end

    rTable.GetCardDetails = function()
        if self.cardActive then
            local cardTable = {['cardNumber'] = tonumber(self.cardNumber), ['cardPin'] = tonumber(self.cardPin), ['cardStatus'] = self.cardActive, ['cardLocked'] = self.cardLocked, ['type'] = self.cardType }
            return cardTable
        else
            return nil
        end
    end

    rTable.UpdateDebitCardPin = function(pin)
        exports['ghmattimysql']:execute("UPDATE `bank_accounts` SET `cardPin` = @pin WHERE `character_id` = @cid AND `record_id` = @acct", {['@cid'] = self.cid, ['@acct'] = self.aid, ['@pin'] = pin}, function(rowsChanged)
            if rowsChanged == 1 then
                self.cardPin = pin
                self.updateItemPin(pin)
                bankCards[tonumber(self.cardNumber)].pin = self.cardPin
            end
        end)
    end

    rTable.updateSource = function(src)
        if src ~= nil and type(src) == "number" then 
            self.source = src
        else
            self.source = -1
        end
    end

    rTable.GetStatement = function()
        return self.bankStatement
    end

    rTable.GetAccountNo = function()
        return self.account
    end

    rTable.GetSortCode = function()
        return self.sortcode
    end

    rTable.AddMoney = function(amt, text)
        local success
        local Addprocessed = false
        if type(amt) == "number" and text then
            self.balance = self.balance + amt
            local successBank = self.saveAccount()
            if successBank then
                local time = os.date("%Y-%m-%d %H:%M:%S")
                exports['ghmattimysql']:execute("INSERT INTO `bank_statements` (`account`, `character_id`, `account_number`, `sort_code`, `deposited`, `withdraw`, `balance`, `date`, `type`) VALUES (@accountty, @cid, @account, @sortcode, @deposited, @withdraw, @balance, @date, @type)", {
                    ['@accountty'] = "Current",
                    ['@cid'] = self.cid,
                    ['@account'] = self.account,
                    ['@sortcode'] = self.sortcode,
                    ['@deposited'] = amt,
                    ['@withdraw'] = nil,
                    ['@balance'] = self.balance,
                    ['@date'] = time,
                    ['@type'] = text
                }, function(statementUpdated)
                    if statementUpdated > 0 then
                        local statementTable = {['withdraw'] = nil, ['deposited'] = amt, ['type'] = text, ['sort_code'] = self.sortcode, ['date'] = time, ['balance'] = self.balance, ['account'] = "Current", ['record_id'] = statementUpdated, ['account_number'] = self.account, ['character_id'] = self.cid }
                        table.insert(self.bankStatement, statementTable)
        
                        if self.source ~= -1 then
                            TriggerClientEvent('pw:updateBank', self.source, self.amount)
                        end
                        success = true
                    else
                        success = false
                    end
                    Addprocessed = true
                end)
                local statementTable = {['withdraw'] = nil, ['deposited'] = amt, ['type'] = text, ['sort_code'] = self.sortcode, ['date'] = time, ['balance'] = self.balance, ['account'] = "Current", ['record_id'] = statementUpdated, ['account_number'] = self.account, ['character_id'] = self.cid }
                table.insert(self.bankStatement, statementTable)

                if self.source ~= -1 then
                    TriggerClientEvent('pw:updateBank', self.source, self.amount)
                end
            else
                success = false
                self.balance = self.balance - amt
                Addprocessed = true
            end
        end
        repeat Wait(0) until Addprocessed == true
        return success
    end

    rTable.RemoveMoney = function(amt, text)
        local successOri
        local Reprocessed = false
        if type(amt) == "number" and text then
            if amt <= self.balance then
                self.balance = self.balance - amt
                local successBank = self.saveAccount()

                if successBank then
                    local time = os.date("%Y-%m-%d %H:%M:%S")
                    exports['ghmattimysql']:execute("INSERT INTO `bank_statements` (`account`, `character_id`, `account_number`, `sort_code`, `deposited`, `withdraw`, `balance`, `date`, `type`) VALUES (@accountty, @cid, @account, @sortcode, @deposited, @withdraw, @balance, @date, @type)", {
                        ['@accountty'] = "Current",
                        ['@cid'] = self.cid,
                        ['@account'] = self.account,
                        ['@sortcode'] = self.sortcode,
                        ['@deposited'] = nil,
                        ['@withdraw'] = amt,
                        ['@balance'] = self.balance,
                        ['@date'] = time,
                        ['@type'] = text
                    }, function(statementUpdated)
                        if statementUpdated > 0 then
                            successOri = true
                            local statementTable = {['withdraw'] = amt, ['deposited'] = nil, ['type'] = text, ['sort_code'] = self.sortcode, ['date'] = time, ['balance'] = self.balance, ['account'] = "Current", ['record_id'] = statementUpdated, ['account_number'] = self.account, ['character_id'] = self.cid }
                            table.insert(self.bankStatement, statementTable)

                            if self.source ~= -1 then
                                TriggerClientEvent('pw:updateBank', self.source, self.amount)
                            end
                            Reprocessed = true
                        else
                            successOri = false
                            Reprocessed = true
                        end
                    end)
                else
                    successOri = false
                    self.balance = self.balance + amt
                    Reprocessed = true
                end
            end
        end
        repeat Wait(0) until Reprocessed == true
        return successOri
    end

    return rTable
end



RegisterServerEvent('qb-banking:server:registerCurrentAccount')
AddEventHandler('qb-banking:server:registerCurrentAccount', function(cid)
    if not currentAccounts[cid] then
        currentAccounts[cid] = generateCurrent(cid)
    end
end)

function generateSavings(cid)
    local self  = {}
    self.cid = cid
    self.source = -1

    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_accounts` WHERE `citizenid` = '" .. self.cid .."' AND `account_type` = 'Savings'", function(getSavingsAccount)
        if getSavingsAccount[1] ~= nil then
            self.aid = getSavingsAccount[1].record_id
            self.balance = getSavingsAccount[1].amount
        end
        
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_statements` WHERE `account` = 'Savings' AND `citizenid` = '" .. self.cid .. "' ORDER BY `record_id` DESC LIMIT 30", function(stats)
            self.bankStatement = stats
        end)
    end)



    self.saveAccount = function()
        exports.ghmattimysql:execute('UPDATE bank_accounts SET amount=@amount WHERE citizenid=@citizenid AND record_id=@record_id', {
            ['@amount'] = self.balance,
            ['@citizenid'] = self.cid,
            ['@record_id'] = self.aid
        }, function(success)
            if success then
                return true
            else
                return false
            end
        end)
    end

    local rTable = {}

    rTable.GetBalance = function()
        return self.balance
    end

    rTable.getStatement = function()
        return self.bankStatement
    end

    rTable.getAccount = function()
        local returnTable = { ['account'] = self.account, ['sortcode'] = self.sortcode }
        return returnTable
    end

    rTable.updateSource = function(src)
        if src ~= nil and type(src) == "number" then 
            self.source = src
        else
            self.source = -1
        end
    end

    rTable.AddMoney = function(amt, text)
        if type(amt) == "number" and text then
            self.balance = self.balance + amt
            local success = self.saveAccount()
            local time = os.date("%Y-%m-%d %H:%M:%S")
            exports.ghmattimysql:execute('INSERT INTO bank_statements (citizenid, account, deposited, withdraw, balance, date, type) VALUES (@citizenid, @account, @deposited, @withdraw, @balance, @date, @type)', {
                ['@citizenid'] = self.cid,
                ['@account'] = 'Saving',
                ['@deposited'] = amt,
                ['@withdraw'] = 0,
                ['@balance'] = self.balance,
                ['@date'] = time,
                ['@type'] = text
            })
            local statementTable = {['withdraw'] = nil, ['deposited'] = amt, ['type'] = text,  ['date'] = time, ['balance'] = self.balance, ['account'] = "Savings", ['record_id'] = statementUpdate, ['character_id'] = self.cid }
            table.insert(self.bankStatement, statementTable)
            return true 
        end
    end

    rTable.RemoveMoney = function(amt, text)
        if type(amt) == "number" and text then
            if amt <= self.balance then
                self.balance = self.balance - amt
                local success = self.saveAccount()
                local time = os.date("%Y-%m-%d %H:%M:%S")
                exports.ghmattimysql:execute('INSERT INTO bank_statements (citizenid, account, deposited, withdraw, balance, date, type) VALUES (@citizenid, @account, @deposited, @withdraw, @balance, @date, @type)', {
                    ['@citizenid'] = self.cid,
                    ['@account'] = 'Saving',
                    ['@deposited'] = 0,
                    ['@withdraw'] = amt,
                    ['@balance'] = self.balance,
                    ['@date'] = time,
                    ['@type'] = text
                })
                local statementTable = {['withdraw'] = amt, ['deposited'] = nil, ['type'] = text,  ['date'] = time, ['balance'] = self.balance, ['account'] = "Savings", ['record_id'] = statementUpdate, ['character_id'] = self.cid }
                table.insert(self.bankStatement, statementTable)
                return true
            end
        end
    end

    return rTable
end

RegisterServerEvent('qb-banking:server:registerSavingsAccount')
AddEventHandler('qb-banking:server:registerSavingsAccount', function(cid)
    if not savingsAccounts[cid] then
        savingsAccounts[cid] = generateSavings(cid)
    end
end)

function createSavingsAccount(cid)
    print(cid)
    local completed = false
    local success = false
    exports.ghmattimysql:execute('INSERT INTO bank_accounts (citizenid, amount, account_type) VALUES (@citizenid, @amount, @account_type)', {
        ['@citizenid'] = cid,
        ['@amount'] = 0,
        ['@account_type'] = 'Savings'
    }, function(result)
        savingsAccounts[cid] = generateSavings(cid)
        success = true
        completed = true
    end)
    repeat Wait(0) until completed == true
    return success
end

exports('createSavingsAccount', function(cid)
    return createSavingsAccount(cid)
end)
