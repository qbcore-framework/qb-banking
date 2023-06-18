local Translations = {
    error = {
        not_give = "Impossible de donner l'objet à cet id.",
        givecash = "Utilisez /givecash [ID] [Montant]",
        wrong_id = "Mauvais ID.",
        dead = "Vous êtes mort.",
        too_far_away = "Vous êtes trop loin.",
        not_enough = "Vous n'avez pas assez d'argent.",
        invalid_amount = "Montant invalide.",
    },
    success = {
        debit_card = "Vous avez demandé une carte de débit.",
        cash_deposit = "Vous avez fait un dépôt de $%{value}.",
        cash_withdrawal = "Vous avez fait un retrait de $%{value}.",
        updated_pin = "Vous avez mis à jour votre code PIN.",
        savings_deposit = "Vous avez déposé $%{value} sur votre compte épargne.",
        savings_withdrawal = "Vous avez retiré $%{value} de votre compte épargne.",
        opened_savings = "Vous avez ouvert votre compte épargne.",
        give_cash = "Vous avez donné $%{cash} à %{id}",
        received_cash = "Vous avez reçu $%{cash} de %{id}"
    },
    info = {
        bank_blip = "Banque",
        access_bank_target = "Accéder à la banque",
        access_bank_key = "[E] - Accéder à la banque",
        current_to_savings = "Transférer de l'argent de votre compte courant vers votre compte épargne",
        savings_to_current = "Transférer de l'argent de votre compte épargne vers votre compte courant",
        deposit = "Dépôt de $%{amount} dans le compte courant",
        withdraw = "Retrait $%{amount} depuis le compte courant",
    },
    command = {
        givecash = "Donner du cash à un joueur."
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
