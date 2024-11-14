local Translations = {
    success = {
        withdraw = 'Retiro exitoso',
        deposit = 'Depósito exitoso',
        transfer = 'Transferencia exitosa',
        account = 'Cuenta creada',
        rename = 'Cuenta renombrada',
        delete = 'Cuenta eliminada',
        userAdd = 'Usuario añadido',
        userRemove = 'Usuario eliminado',
        card = 'Tarjeta creada',
        give = 'Se dieron $%s en efectivo',
        receive = 'Se recibieron $%s en efectivo',
    },
    error = {
        error = 'Ocurrió un error',
        access = 'No autorizado',
        account = 'Cuenta no encontrada',
        accounts = 'Número máximo de cuentas creadas',
        user = 'Usuario ya añadido',
        noUser = 'Usuario no encontrado',
        money = 'No hay suficiente dinero',
        pin = 'PIN inválido',
        card = 'No se encontró tarjeta bancaria',
        amount = 'Monto inválido',
        toofar = 'Estás demasiado lejos',
    },
    progress = {
        atm = 'Accediendo al cajero automático',
    }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Lang or Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })
end
