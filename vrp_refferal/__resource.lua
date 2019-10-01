resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description "giftbox"

dependencies {
	'vrp',
	'vrp_mysql'
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  '@mysql-async/lib/MySQL.lua',
  "server.lua"
}
