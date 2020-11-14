extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var SERVER_PORT = 1025;
export  var MAX_PLAYERS = 10;
var number_of_game = 0

onready var gameViewerNode = $Lobby/ViewportContainer/Viewport/GameViewer

var Game_Instance_NODE = preload("../Scenes/Game_instance.tscn")

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
	$Lobby._new_player(playerid,"NotIdentified")

func _Peer_disconnected(playerid):
	print("User "+str(playerid) + " disconnected")
	$Lobby._remove_player(playerid)

func _process(delta):
	#_return_players_position(get_parent().p1_x,get_parent().p1_y,get_parent().p2_x,get_parent().p2_y)
	#_return_server_ball_info(_player1Id,_player1Id_con);
	#_return_server_ball_info(_player2Id,_player2Id_con);
	pass

func _on_Timer1s_timeout():
	_return_List_of_Player_connected()



########################### SERVER PING ########################################
remote func ping():
	var playerid = get_tree().get_rpc_sender_id();
	rpc_unreliable_id(playerid,"_return_ping")

###########################SERVER LOBBY########################################
var waiting_player_id
var second_waiting_player_id
var waiting = false

remote func _Player_Enter_Lobby(player_name):
	var playerid = get_tree().get_rpc_sender_id();
	if($Lobby._is_playerid_connected(playerid)):
		$Lobby._set_player_name(playerid,player_name)
	#
func _return_List_of_Player_connected():
	rpc("_return_list_of_players",$Lobby._return_list_of_player_in_lobby())

remote func _automatch():
	var playerid = get_tree().get_rpc_sender_id();
	if(!waiting):
		waiting_player_id = playerid
		waiting = true
	else:
		second_waiting_player_id = playerid
		waiting = false
		_start_match()
	
func _start_match():
	var game_Instance = Game_Instance_NODE.instance()
	game_Instance.init(waiting_player_id,second_waiting_player_id)
	add_child(game_Instance)
	game_Instance.name=str(number_of_game)
	 
	number_of_game += 1
	$Lobby._set_player_game_instance_id(waiting_player_id,game_Instance.name)
	$Lobby._set_player_game_instance_id(second_waiting_player_id,game_Instance.name)
	rpc_id(waiting_player_id,"_start_match")
	rpc_id(second_waiting_player_id,"_start_match")
	
###########################GAME INSTANCE########################################
remote func _StartGame():
	var playerid = get_tree().get_rpc_sender_id();
	print("player id :" + str(playerid) + " want to start the game");
	var gameInstanceID = $Lobby._get_player_game_instance_id(playerid)
	var gameInstance = get_node(gameInstanceID)
	gameInstance.play()
	
func _return_server_ball_info(playerid,dx,dy,playing):
	rpc_unreliable_id(playerid,"_return_server_ball_info",dx,dy,playing)

func _return_ball_hit(playerId,player_number):
	rpc_id(playerId,"_return_ball_hit",player_number)

func _return_players_position(playerId,p1x,p1y,p2x,p2y):
		rpc_unreliable_id(playerId,"_return_players_position",p1x,p1y,p2x,p2y)

func _return_score_info(playerid,p1_score,p2_score):
	rpc_id(playerid,"_return_score_info",p1_score,p2_score)
	
func _return_DisplayMessage(playerid,message,visible):
	rpc_id(playerid,"_return_DisplayMessage",message,visible)	
	
remote func _ReturnPlayersControl(KEY_UP_pressed,KEY_DOWN_pressed):
	var playerid = get_tree().get_rpc_sender_id();
	var gameInstanceID = $Lobby._get_player_game_instance_id(playerid)
	var gameInstance = get_node(gameInstanceID)
	gameInstance.set_control(playerid,Helpers.convert_string_to_bool(KEY_UP_pressed),Helpers.convert_string_to_bool(KEY_DOWN_pressed))

	
	


