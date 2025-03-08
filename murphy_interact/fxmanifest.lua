fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

use_experimental_fxv2_oal 'yes'
lua54 'yes'

name 'interact'
author 'darktrovx, chatdisabled, fjamzoo, pushkart2, levraimurphy'
description 'Interaction system'
repository 'https://github.com/darktrovx/interact'

files {
    'client/interactions.lua',
    'client/utils.lua',
    'client/entities.lua',
    'shared/settings.lua',
    'shared/log.lua',
    'bridge/**/client.lua',
    'assets/**/*.png',
    'assets/*.ytd'
}


shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'bridge/init.lua',
    'client/textures.lua',
    'client/interacts.lua',
    'client/raycast.lua',
    'client/defaults.lua',
}

server_scripts {
    'server/main.lua',
}
dependency 'ox_lib'

