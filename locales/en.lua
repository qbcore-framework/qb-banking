local Translations = {
    success = {
        withdraw = 'Withdraw successful',
        deposit = 'Deposit successful',
        transfer = 'Transfer successful',
        account = 'Account created',
        rename = 'Account renamed',
        delete = 'Account deleted',
        userAdd = 'User added',
        userRemove = 'User removed',
        card = 'Card created',
        give = '$%s cash given',
        receive = '$%s cash received',
    },
    error = {
        error = 'An error occurred',
        access = 'Not authorized',
        account = 'Account not found',
        accounts = 'Max accounts created',
        user = 'User already added',
        noUser = 'User not found',
        money = 'Not enough money',
        pin = 'Invalid PIN',
        card = 'No bank card found',
        amount = 'Invalid amount',
        toofar = 'You are too far away',
    },
    progress = {
        atm = 'Accessing ATM',
    },
    ui = {
        cash = 'Cash',
        accountNumber = 'Account Number: ',
        home = 'Home',
        transfer = 'Transfer',
        accountOptions = 'Account Options',
        moneyManagement = 'Money Management',
        account = 'Account: ',
        amount = 'Amount: ',
        reason = 'Reason: ',
        withdraw = 'Withdraw',
        deposit = 'Deposit',
        internal = 'Internal',
        external = 'External',
        orderDebitCard = 'Order Debit Card',
        pinNumber = 'Pin Number: ',
        openSharedAccount = 'Open Shared Account',
        name = 'Name: ',
        openAccount = 'Open Account',
        manageSharedAccount = 'Manage Shared Account',
        delete = 'Delete',
        rename = 'Rename',
        add = 'Add',
        remove = 'Remove',
        enterPin = 'Enter Pin',
        clear = 'Clear',
        submit = 'Submit',
        openAtm = 'Open ATM',
        openBank = 'Open Bank',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
