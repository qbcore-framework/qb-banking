local Translations = {
    success = {
        withdraw = 'Výběr byl úspěšný',
        deposit = 'Deposit byl úspěšný',
        transfer = 'Převod byl úspěšný',
        account = 'Účet vytvořen',
        rename = 'Účet přejmenován',
        delete = 'Účet smazán',
        userAdd = 'Uživatel přidán',
        userRemove = 'Uživatel odstraněn',
        card = 'Karta vytvořena',
        give = '$%s peníze dány',
        receive = '$%s peníze získány',
    },
    error = {
        error = 'Došlo k chybě',
        access = 'Neautorizováno',
        account = 'Účet nebyl nalezen',
        accounts = 'Max. počet vytvořených účtů',
        user = 'Uživatel již přidán',
        noUser = 'Uživatel nenalezen',
        money = 'Nedostatek peněz',
        pin = 'Neplatný PIN',
        card = 'Nenalezena žádná bankovní karta',
        amount = 'Neplatná částka',
        toofar = 'Jsi příliš daleko',
    },
    progress = {
        atm = 'Zadávaš PIN do bankomatu',
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end