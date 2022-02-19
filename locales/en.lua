local Translations = {
    error = {
        not_give = "Could not give item to the given id.",
        givecash = "Usage /givecash [ID] [AMOUNT]",
        wrong_id = "Wrong ID.",
        dead = "You are dead LOL.",
        too_far_away = "You are too far away lmfao.",
        not_enough = "You don\'t have this amount.",
        invalid_amount = "Invalid amount given"
    },
    success = {
        debit_card = "You have successfully ordered a Debit Card.",
        cash_deposit = "You made a cash deposit of $%{value} successfully.",
        cash_withdrawal = "You made a cash withdrawal of $%{value} successfully.",
        updated_pin = "You have successfully updated your debit card pin.",
        savings_deposit = "You made a savings deposit of $%{value} successfully.",
        savings_withdrawal = "You made a savings withdrawal of $%{value} successfully.",
        opened_savings = "You have successfully opened a savings account.",
        give_cash = "Success fully gave to ID %{id} $%{cash}.",
        recived_cash = "Success recived gave $%{cash} from ID %{id}"
    },
    info = {
        bank_blip = "Bank",
        access_bank = "~g~E~w~ - Access Bank",
        current_to_savings = "Current Account to Savings Transfer",
        savings_to_current = "Savings to Current Account Transfer"
    },
    command = {
        givecash = "Give cash to player."
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
