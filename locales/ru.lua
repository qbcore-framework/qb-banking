local Translations = {
    error = {
        not_give = "Вы не можете передать предмет этому ID.",
        givecash = "Используйте /givecash [ID] [AMOUNT]",
        wrong_id = "Не правильный ID",
        dead = "Ты мертв ЛОЛ",
        too_far_away = "Вы слишком далеко",
        not_enough = "У вас нет такой суммы",
        invalid_amount = "Указана неверная сумма"
    },
    success = {
        debit_card = "Вы успешно заказали дебетовую карту",
        cash_deposit = "Вы успешно внесли деньги в размере $%{value}.",
        cash_withdrawal = "Вы успешно сняли деньги в размере $%{value}.",
        updated_pin = "Вы успешно обновили ПИН-код на дебетовой карте.",
        savings_deposit = "Вы успешно внесли деньги на сберегательный счет в размере $%{value}.",
        savings_withdrawal = "Вы успешно сняли деньги со сберегательного счета в размере $%{value}.",
        opened_savings = "Вы успешно открыли сбегерательный счет.",
        give_cash = "Вы успешно передали деньги в размере $%{cash}  %{id}",
        received_cash = Игрок с ID %{id} передал вам деньги в размере $%{cash} "
    },
    info = {
        bank_blip = "Банк",
        access_bank_target = "Войти в банк",
        access_bank_key = "[E] - Войти в банк",
        current_to_savings = Перевести на сберегательный счет",
        savings_to_current = "Перевести на дебетовый счет",
        deposit = "Внесение $%{amount} на текущий счет",
        withdraw = "Снятия $%{amount} с текущего счета",
    },
    command = {
        givecash = "Дать наличку игроку."
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
