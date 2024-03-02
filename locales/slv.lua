local Translations = {
    success = {
        withdraw = 'Uspešno dvignili denar',
        deposit = 'Uspešno naložili denar',
        transfer = 'Uspešno prenesli denar',
        account = 'Račun narejen',
        rename = 'Račun preimenovan',
        delete = 'Račun izbrisan',
        userAdd = 'Uporabnik dodan',
        userRemove = 'Uporabnik odstranjen',
        card = 'Kreditna kartica ustvarjena',
        give = '$%s gotovina dana',
        receive = '$%s gotovina projeta',
    },
    error = {
        error = 'Zgodila se je napaka',
        access = 'Niste pooblaščeni',
        account = 'Računa ni bilo mogoče najti',
        accounts = 'Maksimalno število računov ustvarjenih',
        user = 'Uporabnik že dodan',
        noUser = 'Računa ni bilo mogoče najti',
        money = 'Nimate dovolj denarja',
        pin = 'Neveljaven PIN',
        card = 'Kreditne kartice ni bilo mogoče najti',
        amount = 'Neveljavna številka',
        toofar = 'Si pre daleč',
    },
    progress = {
        atm = 'Dostopanje do bankomata',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
