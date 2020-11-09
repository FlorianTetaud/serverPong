extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SERVER_PORT = 1025;
var MAX_PLAYERS = 2;
var _player1Id = 0
var _player1Id_con : bool = false;
var KEY_UP_p1_pressed : bool = false;
var KEY_DOWN_p1_pressed : bool = false;
var _player2Id = 0;
var _player2Id_con : bool = false;
var KEY_UP_p2_pressed : bool = false;
var KEY_DOWN_p2_pressed : bool = false;

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
	if(!_player1Id_con):
		print("User 1 : id "+str(playerid) + " connected")
		_player1Id = playerid;
		_player1Id_con = true;
	else:
		print("User 2 : id "+str(playerid) + " connected")
		(_player2Id) = playerid;
		_player2Id_con = true;
	pass
func _Peer_disconnected(playerid):
	print("User "+str(playerid) + " disconnected")
	if(_player1Id == playerid):
		_player1Id_con = false;
	if(_player2Id == playerid):
		_player2Id_con = false;		
	pass


	
remote func _StartGame():
	var playerid = get_tree().get_rpc_sender_id();
	print("player id :" + str(playerid) + " want to start the game");
	var PongNode = get_parent()
	var BallNode = PongNode.get_node("Ball")
	var data = BallNode.get_ball_position()
	BallNode.playing = true
	pass

func _process(delta):
	_return_players_position(get_parent().p1_x,get_parent().p1_y,get_parent().p2_x,get_parent().p2_y)
	_return_server_ball_info(_player1Id,_player1Id_con);
	_return_server_ball_info(_player2Id,_player2Id_con);
	
remote func _ReturnPlayersControl(KEY_UP_pressed,KEY_DOWN_pressed):
	var playerid = get_tree().get_rpc_sender_id();
	if(_player1Id == playerid):
		KEY_UP_p1_pressed = Helpers.convert_string_to_bool(KEY_UP_pressed);
		KEY_DOWN_p1_pressed =  Helpers.convert_string_to_bool(KEY_DOWN_pressed);
	if(_player2Id == playerid):
		KEY_UP_p2_pressed =  Helpers.convert_string_to_bool(KEY_UP_pressed);
		KEY_DOWN_p2_pressed =  Helpers.convert_string_to_bool(KEY_DOWN_pressed);
	pass
	

func _return_server_ball_info(playerid,_playerId_con):
	if(_playerId_con):
		var PongNode = get_parent()
		var BallNode = PongNode.get_node("Ball")
		var data = BallNode.get_ball_position()
		var dx = str(data.dx)
		var dy = str(data.dy)
		var playing = str(data.playing)
		rpc_unreliable_id(playerid,"_return_server_ball_info",dx,dy,playing)

func _return_players_position(p1x,p1y,p2x,p2y):
	if(_player1Id_con) :
		rpc_unreliable_id(_player1Id,"_return_players_position",p1x,p1y,p2x,p2y)
	if(_player2Id_con) :
		rpc_unreliable_id(_player2Id,"_return_players_position",p1x,p1y,p2x,p2y)		
	pass
