local Translations = {
    error = {
        not_give = "Nepodařilo se převest částku na dané id.",
        givecash = "Použití /givecash [ID] [AMOUNT]",
        wrong_id = "Chybné ID.",
        dead = "Jsi mrtvý LOL.",
        too_far_away = "Jste příliš daleko lmfao.",
        not_enough = "Tuto částku nemáte.",
        invalid_amount = "Neplatná zadaná částka"
    },
    success = {
        debit_card = "Úspěšně jste si objednali debetní kartu.",
        cash_deposit = "Úspěšně jste vložili hotovost ve výši $%{value}.",
        cash_withdrawal = "Úspěšně jste provedli výběr hotovosti ve výši $%{value}.",
        updated_pin = "Úspěšně jste aktualizovali pin své debetní karty.",
        savings_deposit = "Úspěšně jste uložili úspory ve výši $%{value}.",
        savings_withdrawal = "Úspěšně jste provedli výběr úspor ve výši $%{value}.",
        opened_savings = "Úspěšně jste si založili spořicí účet.",
        give_cash = "Úspěšně předáno $%{cash} na ID %{id}",
        received_cash = "Úspěšně obdržel $%{cash} z ID %{id}"
    },
    info = {
        bank_blip = "Banka",
        access_bank_target = "Otevřít Banku",
        access_bank_key = "[E] - Otevřít Banku",
        current_to_savings = "Převod běžného účtu na spořicí účet",
        savings_to_current = "Převod úspor na běžný účet",
        deposit = "Vložit $%{amount} na běžný účet",
        withdraw = "Vybrat $%{amount} z běžného účtu",
    },
    command = {
        givecash = "Dát hráči hotovost"
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
