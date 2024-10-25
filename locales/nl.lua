local Translations = {
    success = {
        withdraw = 'Sucessvol opgenomen',
        deposit = 'Succesvol gestort',
        transfer = 'Succesvol overgeschreven',
        account = 'Account aangemaakt',
        rename = 'Naamaanpassing is gelukt',
        delete = 'Account verwijderd',
        userAdd = 'Account aangemaakt',
        userRemove = 'Account verwijderd',
        card = 'Kaart aangemaakt',
        give = '€%s cash gegeven',
        receive = '€%s cash ontvangen',
    },
    error = {
        error = 'Er is error opgedoken',
        access = 'Je bent niet gemachtigd',
        account = 'Account niet gevonden',
        accounts = 'Maximum aantal account gemaakt',
        user = 'Account reeds toegevoegd',
        noUser = 'Account niet gevonden',
        money = 'Je hebt niet genoeg geld',
        pin = 'Foutieve pincode',
        card = 'Geen bankkaart gevonden',
        amount = 'Foute hoeveelheid',
        toofar = 'Je bent te ver weg',
    },
    progress = {
        atm = 'ATM gebruiken',
    }
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Lang or Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
