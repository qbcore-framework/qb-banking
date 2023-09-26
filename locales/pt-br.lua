local Translations = {
    error = {
        not_give = "Não foi possível dar o item ao ID fornecido.",
        givecash = "Uso /givecash [ID] [VALOR]",
        wrong_id = "ID incorreto.",
        dead = "Você está morto, haha.",
        too_far_away = "Você está muito longe, risos.",
        not_enough = "Você não tem essa quantia.",
        invalid_amount = "Quantidade inválida fornecida."
    },
    success = {
        debit_card = "Você solicitou com sucesso um Cartão de Débito.",
        cash_deposit = "Você fez com sucesso um depósito em dinheiro de $%{valor}.",
        cash_withdrawal = "Você fez com sucesso um saque em dinheiro de $%{valor}.",
        updated_pin = "Você atualizou com sucesso o PIN do seu cartão de débito.",
        savings_deposit = "Você fez com sucesso um depósito na conta poupança de $%{valor}.",
        savings_withdrawal = "Você fez com sucesso um saque na conta poupança de $%{valor}.",
        opened_savings = "Você abriu com sucesso uma conta poupança.",
        give_cash = "Você deu com sucesso $%{dinheiro} para o ID %{id}.",
        received_cash = "Você recebeu com sucesso $%{dinheiro} do ID %{id}."
    },
    info = {
        bank_blip = "Banco",
        access_bank_target = "Acesse o Banco",
        access_bank_key = "[E] - Acessar o Banco",
        current_to_savings = "Transferir Conta Corrente para Conta Poupança",
        savings_to_current = "Transferir Poupança para Conta Corrente",
        deposit = "Depositar $%{quantidade} na Conta Corrente",
        withdraw = "Sacar $%{quantidade} da Conta Corrente",
    },
    command = {
        givecash = "Dar dinheiro a um jogador."
    }
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
