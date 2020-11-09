extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SERVER_PORT = 1025;
var MAX_PLAYERS = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)

	get_tree().network_peer = peer
	print("server start...")
	
	peer.connect("peer_connected",self,"_Peer_connected")
	peer.connect("peer_disconnected",self,"_Peer_disconnected")
	pass # Replace with function body.

func _Peer_connected(playerid):
	print("User "+str(playerid) + " connected")
	pass
func _Peer_disconnected(playerid):
	print("User "+str(playerid) + " disconnected")
	pass

remote func _ReturnPlayerPosition(moveDirection):
	var playerid = get_tree().get_rpc_sender_id();
	#write the code to move the player
	pass
	
remote func _StartGame():
	var playerid = get_tree().get_rpc_sender_id();
	print("player id :" + str(playerid) + " want to start the game");
	var PongNode = get_parent()
	var BallNode = PongNode.get_node("Ball")
	var data = BallNode.get_ball_position()
	BallNode.playing = true
	pass

remote func _fetch_server_ball_info():
	var playerid = get_tree().get_rpc_sender_id()
	var PongNode = get_parent()
	var BallNode = PongNode.get_node("Ball")
	var data = BallNode.get_ball_position()
	var dx = str(data.dx)
	var dy = str(data.dy)
	var playing = str(data.playing)
	rpc_id(playerid,"_return_ball_info",dx,dy,playing)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
