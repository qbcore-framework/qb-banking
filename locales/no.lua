local Translations = {
    error = {
        not_give = "Kunne ikke gi elementet til den angitte ID-en.",
        givecash = "Bruk /givecash [ID] [BELØP]",
        wrong_id = "Feil ID.",
        dead = "Du er død.",
        too_far_away = "Du er for langt unna.",
        not_enough = "Du har ikke dette beløpet.",
        invalid_amount = "Ugyldig beløp gitt"
    },
    success = {
        debit_card = "Du har bestilt et debetkort.",
        cash_deposit = "Du har gjort et kontantinnskudd på %{value} KR.",
        cash_withdrawal = "Du har gjort et kontantuttak av %{value} KR.",
        updated_pin = "Du har oppdatert PIN-koden for debetkort.",
        savings_deposit = "Du har gjort et spareinnskudd på %{value} KR.",
        savings_withdrawal = "Du har gjennomført et spareuttak av %{value} KR.",
        opened_savings = "Du har åpnet en sparekonto.",
        give_cash = "Du ga %{cash} KR til ID %{id}",
        received_cash = "Successfully received $%{cash} from ID %{id}"
    },
    info = {
        bank_blip = "Bank",
        access_bank_target = "Åpne Bankkonto",
        access_bank_key = "[E] - Åpne Bankkonto",
        current_to_savings = "Overfør nåværende konto til sparing",
        savings_to_current = "Overfør sparepenger til gjeldende konto",
        deposit = "Du satt %{amount} KR inn på din nåværende konto",
        withdraw = "Du tokk ut %{amount} KR fra din konto",
    },
    command = {
        givecash = "Gi penger til spilleren."
    }
}

if GetConvar('qb_locale', 'en') == 'no' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
