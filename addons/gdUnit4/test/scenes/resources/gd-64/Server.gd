extends Node

signal hello

var network = ENetMultiplayerPeer.new()
var max_players = 5

var auth_port = 1911

func _ready():
	StartServer()
	emit_signal("hello")

func StartServer():
	network.connect("peer_connected", Callable(self, "_Peer_Connected"))
	network.connect("peer_disconnected", Callable(self, "_Peer_Disconnected"))
	var err = network.create_server(auth_port, max_players)
	if err != OK:
		prints("Authentication Server start failed.")
		return
	multiplayer.set_multiplayer_peer(network)
	print("Authentication Server start checked port ",auth_port)

func _Peer_Connected(gateway_id):
	print("Gateway " + str(gateway_id) + " is connected")

func _Peer_Disconnected(gateway_id):
	print("Gateway "+ str(gateway_id) + " is disconnected")
