local Translations = {
    success = {
        withdraw = 'Saque bem-sucedido',
        deposit = 'Depósito bem-sucedido',
        transfer = 'Transferência bem-sucedida',
        account = 'Conta criada',
        rename = 'Conta renomeada',
        delete = 'Conta excluída',
        userAdd = 'Usuário adicionado',
        userRemove = 'Usuário removido',
        card = 'Cartão criado',
    },
    error = {
        error = 'Ocorreu um erro',
        access = 'Não autorizado',
        account = 'Conta não encontrada',
        accounts = 'Máximo de contas criadas',
        user = 'Usuário já adicionado',
        noUser = 'Usuário não encontrado',
        money = 'Dinheiro insuficiente',
        pin = 'PIN inválido',
        card = 'Nenhum cartão bancário encontrado',
    },
    progress = {
        atm = 'Acessando o caixa eletrônico',
    },
    ui = {
        cash = 'Dinheiro',
        accountNumber = 'Número da Conta: ',
        home = 'Início',
        transfer = 'Transferência',
        accountOptions = 'Opções de Conta',
        moneyManagement = 'Gestão de Dinheiro',
        account = 'Conta: ',
        amount = 'Valor: ',
        reason = 'Motivo: ',
        withdraw = 'Sacar',
        deposit = 'Depositar',
        internal = 'Interno',
        external = 'Externo',
        orderDebitCard = 'Solicitar Cartão de Débito',
        pinNumber = 'Número do PIN: ',
        openSharedAccount = 'Abrir Conta Compartilhada',
        name = 'Nome: ',
        openAccount = 'Abrir Conta',
        manageSharedAccount = 'Gerenciar Conta Compartilhada',
        delete = 'Excluir',
        rename = 'Renomear',
        add = 'Adicionar',
        remove = 'Remover',
        enterPin = 'Digite o PIN',
        clear = 'Limpar',
        submit = 'Enviar'
    }
}


if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end