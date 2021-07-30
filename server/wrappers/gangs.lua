function loadGangAccount(gangid)
    local self = {}
    self.gid = gangid

    local processed = false
    local query = exports.ghmattimysql:executeSync("SELECT * FROM `bank_accounts` WHERE `gangid` = @gang AND `account_type` = 'Gang'", {['@gang'] = self.gid})
    if query[1] ~= nil then
        self.accountnumber = query[1].account_number
        self.sortcode = query[1].sort_code
        self.balance = query[1].amount
        self.account_type = query[1].account_type
        self.accountid = query[1].record_id
    end
    processed = true

    repeat Wait(0) until processed == true
    processed = false

    local state = exports.ghmattimysql:executeSync("SELECT * FROM `bank_statements` WHERE `account_number` = @ac AND `sort_code` = @sc AND `gangid` = @gid", {['@ac'] = self.accountnumber, ['@sc'] = self.sortcode, ['@gid'] = self.gid})
    self.accountStatement = state
    processed = true

    repeat Wait(0) until processed == true

    self.saveAccount = function()
        exports['ghmattimysql']:execute("UPDATE `bank_accounts` SET `amount` = @balance WHERE `record_id` @aid", {['@balance'] = self.balance, ['@aid'] = self.accountid })
    end

    local rTable = {}

    rTable.getBalance = function()
        return self.balance
    end

    rTable.getStatement = function()
        return self.accountStatement
    end

    rTable.getAccountDetails = function()
        local accountDetails = {['number'] = self.accountnumber, ['sortcode'] = self.sortcode}
        return accountDetails
    end

    --- Update Functions

    rTable.addMoney = function(m)
        if type(m) == "number" then
            self.balance = self.balance + m
            self.saveAccount()
        end
    end

    rTable.removeMoney = function(m)
        if type(m) == "number" then
            if self.balance >= m then
                self.balance = self.balance - m
                self.saveAccount()
                return true
            else
                return false
            end
        end
    end
end

function createGangAccount(gang, startingBalance)
    
    local newBalance = tonumber(startingBalance) or 0

    local checkExists = exports.ghmattimysql:executeSync("SELECT * FROM `bank_accounts` WHERE `gangid` = @gang", {['@gang'] = gang})
    if checkExists[1] == nil then
        local sc = math.random(100000,999999)
        local acct = math.random(10000000,99999999)
        exports['ghmattimysql']:execute("INSERT INTO `bank_accounts` (`gangid`, `account_number`, `sort_code`, `amount`, `account_type`) VALUES (@gang, @acnum, @sc, @bal, 'Gang')", {['@gang'] = gang, ['@acnum'] = acct, ['@sc'] = sc, ['@bal'] = newBalance }, function(success)
            if success > 0 then
                gangAccounts[gang] = loadGangAccount(gang)
            end
        end)
    end
end

exports('createGangAccount', function(gang, starting)
    createGangAccount(gang, starting)
end)