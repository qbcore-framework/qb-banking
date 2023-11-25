local Translations = {
    success = {
        withdraw = 'Prelievo Effettuato',
        deposit = 'Deposito Effettuato',
        transfer = 'Trasferimento Effettuato',
        account = 'Conto corrente Creato',
        rename = 'Conto corrente Rinominato',
        delete = 'Conto corrente Eliminato',
        userAdd = 'Utente Aggiunto',
        userRemove = 'Utente Rimosso',
        card = 'Carta di Credito Creata',
    },
    error = {
        error = 'Errore',
        access = 'Autorizzazione Negata',
        account = 'Conto Corrente non Trovato',
        accounts = 'Hai raggiunto il limite di Conti Correnti da poter creare',
        user = 'Utente già autorizzato',
        noUser = 'Utente non trovato',
        money = 'Non hai abbastanza soldi',
        pin = 'PIN Errato',
        card = 'Nessuna Carta di Credito trovata',
    },
    progress = {
        atm = 'Accesso in corso all\'ATM',
    }
}

if GetConvar('qb_locale', 'en') == 'it' then
    Lang = Lang or Locale:new({ phrases = Translations, warnOnMissing = true })
end
