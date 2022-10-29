class_name Client 
extends Node
	
signal done
var network = ENetMultiplayerPeer.new()
#var multiplayerAPI = MultiplayerAPI.new()

var ip = "127.0.0.1"
var port = 1911
var temp_node = null

func _ready():
	temp_node = Node.new()
	add_child(temp_node)
	
func _process(delta):
	prints("client _process")
	#check whether custom multiplayer api is set
	if get_multiplayer() == null:
		return
	#check whether custom multiplayer network is set
	if not get_multiplayer().has_multiplayer_peer():
		return
	#start custom_multiplayer poll
	get_multiplayer().poll()

func StartClient():
	print("started")
	#connect signals
	network.connect("connection_failed", Callable(self, "_OnConnectionFailed"))
	network.connect("connection_succeeded", Callable(self, "_OnConnectionSucceeded"))
	var err = network.create_client(ip ,port)
	if err != OK:
		prints("Clinet failed", err)
		return
	#multiplayer = multiplayerAPI
	#get_multiplayer().set_root_node(temp_node)
	get_multiplayer().set_multiplayer_peer(network)
	emit_signal("done")

func _OnConnectionFailed():
	pass
	
func _OnConnectionSucceeded():
	pass
