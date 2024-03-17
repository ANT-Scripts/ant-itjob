fx_version 'bodacious'
games { 'gta5' }
lua54 'yes'

author 'ANT Scripts'
description 'A fork of 6x_itcompjob'
version '1.0.0'

client_scripts{
    'client/client.lua',
    'client/delivery.lua'
}

server_scripts {
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}