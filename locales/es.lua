local Translations = {
    success = {
        withdraw = 'Retirado con éxito',
        deposit = 'Depositado con éxito',
        transfer = 'Transferido con éxito',
        account = 'Cuenta creada',
        rename = 'Cuenta renombrada',
        delete = 'Cuenta eliminada',
        userAdd = 'Usuario añadido',
        userRemove = 'Usuario eliminado',
        card = 'Tarjeta creada',
        give = '$%s efectivo entregado',
        receive = '$%s efectivo recibido',
    },
    error = {
        error = 'Ha ocurrido un error',
        access = 'No autorizado',
        account = 'Cuenta no encontrada',
        accounts = 'Número máximo de cuentas creadas',
        user = 'Usuario ya agregado',
        noUser = 'Usuario no encontrado',
        money = 'Sin dinero suficiente',
        pin = 'PIN Inválido',
        card = 'Tarjeta de banco no encontrada',
        amount = 'Cantidad inválida',
        toofar = 'Estas demasiado lejos',
    },
    progress = {
        atm = 'Accediendo al Cajero',
    }
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Lang or Locale:new({ phrases = Translations, warnOnMissing = true })
end
