local Translations = {
	success = {
    withdraw = 'Hævning vellykket',
    deposit = 'Indsætning vellykket',
    transfer = 'Overførsel vellykket',
    account = 'Konto oprettet',
    rename = 'Konto omdøbt',
    delete = 'Konto slettet',
    userAdd = 'Bruger tilføjet',
    userRemove = 'Bruger fjernet',
    card = 'Kort oprettet',
    give = '$%s kontanter givet',
    receive = '$%s kontanter modtaget',
},
error = {
    error = 'Der opstod en fejl',
    access = 'Ikke autoriseret',
    account = 'Konto ikke fundet',
    accounts = 'Maksimalt antal konti oprettet',
    user = 'Bruger allerede tilføjet',
    noUser = 'Bruger ikke fundet',
    money = 'Ikke nok penge',
    pin = 'Ugyldig PIN-kode',
    card = 'Ingen bankkort fundet',
    amount = 'Ugyldigt beløb',
    toofar = 'Du er for langt væk',
},
progress = {
    atm = 'Åbner hæveautomat',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})