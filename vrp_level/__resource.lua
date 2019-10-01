resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description "Script facut de AlexMihai04"

dependencies {
	'vrp',
	'vrp_mysql'
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  '@mysql-async/lib/MySQL.lua',
  "level.lua"
}

client_scripts{ 
  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "levelc.lua"
}
