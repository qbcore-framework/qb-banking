local Translations = {
    success = {
        withdraw = 'Abhebung erfolgreich',
        deposit = 'Einzahlung erfolgreich',
        transfer = 'Überweisung erfolgreich',
        account = 'Konto erstellt',
        rename = 'Konto umbenannt',
        delete = 'Konto gelöscht',
        userAdd = 'Benutzer hinzugefügt',
        userRemove = 'Benutzer entfernt',
        card = 'Karte erstellt',
    },
    error = {
        error = 'Ein Fehler ist aufgetreten',
        access = 'Nicht autorisiert',
        account = 'Konto nicht gefunden',
        accounts = 'Maximale Anzahl von Konten erstellt',
        user = 'Benutzer bereits hinzugefügt',
        noUser = 'Benutzer nicht gefunden',
        money = 'Nicht genug Geld',
        pin = 'Ungültige PIN',
        card = 'Keine Bankkarte gefunden',
    },
    progress = {
        atm = 'Zugriff auf Geldautomaten',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
