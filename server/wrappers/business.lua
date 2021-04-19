businessAccounts = {}
currentAccounts = {}
savingsAccounts = {}
gangAccounts = {}
bankCards = {}

function tprint (t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end 

function generatebusinessAccount(acc, sc, bid)

    local self = {}

    self.accountNumber = tonumber(acc)
    self.sortCode = tonumber(sc)
    self.bid = bid

    local processed = false
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_accounts` WHERE `account_number` = @acc AND `sort_code` = @sc AND `businessid` = @bid", {['@acc'] = self.accountNumber, ['@sc'] = self.sortCode, ['@bid'] = self.bid}, function(bankAccount)
        if bankAccount[1] ~= nil then
            self.account_id = bankAccount[1].record_id
            self.balance = bankAccount[1].amount
            self.account_type = "business"
            self.account_for = bankAccount[1].business
            if self.account_for == "estateagent" then
                self.account_name = "Real Estates"
            elseif self.account_for == "police" then
                self.account_name = "Police"
            elseif self.account_for == "ems" then
                self.account_name = "EMS Medical Services"
            elseif self.account_for == "taxi" then
                self.account_name = "Taxi Services"
            elseif self.account_for == "cardealer" then
                self.account_name = "Car Dealership"
            end
        end
        processed = true
    end)
    repeat Wait(0) until processed == true

    self.saveAccount = function()
        exports['ghmattimysql']:execute("UPDATE `bank_accounts` SET `amount` = @amount WHERE `record_id` = @rid", {['@amount'] = self.balance, ['@rid'] = self.account_id}, function() end)
    end
    
    local rTable = {}

    rTable.getName = function()
        return self.account_name
    end

    rTable.getType = function()
        return self.account_type
    end

    rTable.getEntity = function()
        return self.account_for
    end

    rTable.getBalance = function()
        return self.balance
    end

    rTable.getBankDetails = function()
        return { ['number'] = self.accountNumber, ['sortcode'] = self.sortCode }
    end

    rTable.getBankStatement = function(limit)
        local resLimit = limit or 30
        local processed = false
        local statement
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_statements` WHERE `account` = 'business' AND `business` = @bus AND `account_number` = @acc AND `sort_code` = @sc AND `businessid` = @bid LIMIT @limit", {['@bus'] = bankAccount[1].business, ['@acc'] = self.accountNumber, ['@sc'] = self.sortCode, ['@limit'] = resLimit, ['@bid'] = self.bid }, function(res)
            statement = res
            processed = true
        end)
        repeat Wait(0) until processed == true
        return statement
    end

    -- Update Functions

    rTable.deductBalance = function(amt, text)
        if type(amt) == "number" and text then
            if amt <= self.balance then
                self.balance = self.balance - amt
                exports['ghmattimysql']:execute("INSERT INTO `bank_statements` (`account`, `business`, `businessid`, `account_number`, `sort_code`, `withdraw`, `balance`, `type`) VALUES('business', @bus, @bid, @ac, @sc, @amt, @bal, @text)", {
                    ['@bus'] = self.account_for,
                    ['@ac'] = self.accountNumber,
                    ['@sc'] = self.sortCode,
                    ['@amt'] = amt,
                    ['@bal'] = self.balance,
                    ['@text'] = text,
                    ['@bid'] = self.bid
                }, function(inserted)
                    if inserted > 0 then
                        self.saveAccount()
                    end
                end)
            end
        end
    end

    rTable.addBalance = function(amt, text)
        if type(amt) == "number" and text then
            self.balance = self.balance + amt
            exports['ghmattimysql']:execute("INSERT INTO `bank_statements` (`account`, `business`, `businessid`, `account_number`, `sort_code`, `deposited`, `balance`, `type`) VALUES('business', @bus, @bid, @ac, @sc, @amt, @bal, @text)", {
                ['@bus'] = self.account_for,
                ['@ac'] = self.accountNumber,
                ['@sc'] = self.sortCode,
                ['@amt'] = amt,
                ['@bal'] = self.balance,
                ['@text'] = text,
                ['@bid'] = self.bid
            }, function(inserted)
                if inserted > 0 then
                    self.saveAccount()
                end
            end)
        end
    end

    rTable.payWages = function()
        -- Need to look into making at some point.Bala
    end

    return rTable
end

-------------------------------------
--- CREATE A NEW business ACCOUNT ---
-------------------------------------

function createbusinessAccount(accttype, bid, startingBalance)
    if businessAccounts[accttype] == nil then
        businessAccounts[accttype] = {}
    end

    local newBalance = tonumber(startingBalance) or 1000000
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `bank_accounts` WHERE `business` = @accttype AND `businessid` = @bid", {['@accttype'] = accttype, ['@bid'] = bid}, function(checkExists)
        if checkExists[1] == nil then
            local sc = math.random(100000,999999)
            local acct = math.random(10000000,99999999)
            exports['ghmattimysql']:execute("INSERT INTO `bank_accounts` (`business`, `businessid`, `account_number`, `sort_code`, `amount`, `account_type`) VALUES (@business, @bid, @acnum, @sc, @bal, 'business')", {['@business'] = accttype, ['@acnum'] = acct, ['@sc'] = sc, ['@bal'] = newBalance, ['@bid'] = bid }, function(success)
                if success > 0 then
                    businessAccounts[accttype][tonumber(bid)] = generatebusinessAccount(acct, sc, bid)
                end
            end)
        end
    end)
end

exports('createbusinessAccount', function(accttype, bid, startingbalance)
    createbusinessAccount(accttype, bid, startingbalance)
end)