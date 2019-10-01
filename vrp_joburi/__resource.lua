dependency "vrp"

ui_page 'html/ui.html'

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"client.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua",
	"cfg/cfg.lua"
}

files{
	"html/debounce.min.js",
	"html/scripts.js",
	"html/styles.css",
	"html/fontcustom.woff",
	"html/ui.html"
}