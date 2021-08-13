fx_version 'adamant'

game 'gta5'

description 'QB-Streetfight'

version '1.0.2'

server_script {
    'server.lua',
    'config.lua'
}

client_script {
    'client.lua',
    'config.lua'
}

shared_scripts { 
	'@qb-core/import.lua',
	'config.lua'
}
