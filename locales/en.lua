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
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
