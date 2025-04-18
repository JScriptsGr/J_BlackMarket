fx_version "adamant"
game "gta5"
lua54 "yes"

author "J_Scripts"
version "1.0.0"

client_scripts { "client/**/*.lua", "shared/Config.lua" }
server_scripts { "server/**/*.lua" }
shared_scripts {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua", 
}

escrow_ignore {
    "shared/Config.lua"
}

dependencies {
    'ox_lib'
}    