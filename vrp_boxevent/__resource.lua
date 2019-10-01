resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependencies {
	'vrp',
	'vrp_mysql'
}

client_scripts{
  "@vrp/lib/utils.lua",
	"lib/Tunnel.lua",
	"lib/Proxy.lua", 
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}