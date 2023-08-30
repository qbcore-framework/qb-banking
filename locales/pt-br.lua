local Translations = {
    error = {
        not_give = "Não foi possível dar o item para o ID fornecido.",
        givecash = "Uso /darDinheiro [ID] [QUANTIA]",
        wrong_id = "ID incorreto.",
        dead = "Você está morto, haha.",
        too_far_away = "Você está muito longe, hahaha.",
        not_enough = "Você não tem essa quantia.",
        invalid_amount = "Quantia inválida fornecida"
    },
    success = {
        debit_card = "Você solicitou com sucesso um Cartão de Débito.",
        cash_deposit = "Você fez com sucesso um depósito em dinheiro de $%{value}.",
        cash_withdrawal = "Você fez com sucesso um saque em dinheiro de $%{value}.",
        updated_pin = "Você atualizou com sucesso o PIN do seu cartão de débito.",
        savings_deposit = "Você fez com sucesso um depósito na conta poupança de $%{value}.",
        savings_withdrawal = "Você fez com sucesso um saque na conta poupança de $%{value}.",
        opened_savings = "Você abriu com sucesso uma conta poupança.",
        give_cash = "Você deu com sucesso $%{cash} para o ID %{id}",
        received_cash = "Você recebeu com sucesso $%{cash} do ID %{id}"
    },
    info = {
        bank_blip = "Banco",
        access_bank_target = "Acessar o Banco",
        access_bank_key = "[E] - Acessar o Banco",
        current_to_savings = "Transferir da Conta Corrente para a Conta Poupança",
        savings_to_current = "Transferir da Conta Poupança para a Conta Corrente",
        deposit = "Depositar $%{amount} na Conta Corrente",
        withdraw = "Sacar $%{amount} da Conta Corrente",
    },
    command = {
        givecash = "Dar dinheiro para o jogador."
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
