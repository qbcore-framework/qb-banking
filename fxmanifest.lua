fx_version 'cerulean'
game 'gta5'

description 'QB-Banking'
version '1.2.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/wrappers/business.lua',
    'server/wrappers/useraccounts.lua',
    'server/wrappers/gangs.lua',
    'server/atm.lua',
    'server/bank.lua',
}

client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/atm.lua',
    'client/bank.lua',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/app.js',
    'nui/atm/images/logo.png',
    'nui/atm/images/logo1.png',
    'nui/atm/images/mastercard.png',
    'nui/atm/images/visa.png',
    'nui/atm/index.html',
    'nui/atm/app.js',
    'nui/atm/style.css',
    'nui/bank/images/logo.png',
    'nui/bank/index.html',
    'nui/bank/app.js',
    'nui/bank/style.css',
}

lua54 'yes'
use_fxv2_oal 'yes'
