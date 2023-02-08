fx_version "adamant"

games { 'rdr3' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
	'utils/hairs.lua',
	'utils/cloth_hash_names.lua',
	'utils/overlays.lua',
	'utils/features.lua',
	'utils/functions.lua',
	'config.lua',
	'client/cl_main.lua',
}

server_scripts {
	'server/sv_main.lua',
	'@oxmysql/lib/MySQL.lua',
}

files {
	'img/*.png',
}

lua54 'yes'
