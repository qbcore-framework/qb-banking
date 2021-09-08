fx_version 'cerulean'
game 'gta5'

description 'QB-Banking'
version '1.0.0'

shared_scripts { 
	'@qb-core/import.lua',
	'config/config.lua',
}

server_scripts {
    'server/wrappers/business.lua',
    'server/wrappers/useraccounts.lua',
    'server/wrappers/gangs.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/nui.lua'
}

ui_page 'html/index.html'

files {
    'html/images/*.png',
    'html/scripting/jquery-ui.css',
    'html/scripting/external/jquery/jquery.js',
    'html/scripting/jquery-ui.js',
    'html/style.css',
    'html/index.html',
    'html/banking.js',
}
