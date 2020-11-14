extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lobbyList : LobbyList


# Called when the node enters the scene tree for the first time.
func _ready():
	lobbyList = LobbyList.new()
	pass # Replace with function body.

func _new_player(playerId,playerName):
	lobbyList._append_player(playerId,Player.new(playerName,playerId))

func _remove_player(playerId):
	lobbyList._remove_player(playerId)

func _set_player_name(playerid, playername):
	lobbyList._return_player_from_id(playerid)._playerName = playername
	
func _set_player_game_instance_id(playerid, gameInstanceId):
	lobbyList._return_player_from_id(playerid)._playerGameInstanceId = gameInstanceId

func _get_player_game_instance_id(playerid):
	return lobbyList._return_player_from_id(playerid).return_player_game_id()

func _remove_player_from_game_instance_id(playerid, gameInstanceId):
	lobbyList._return_player_from_id(playerid)._playerGameInstanceId = 0

func _is_playerid_connected(playerid):
	return lobbyList._listOfPlayerConnected.has(playerid)
	
func _return_list_of_player_in_lobby():
	var listOfPlayer: String = ""
	for i in lobbyList._listOfPlayerConnected:
		listOfPlayer = str(listOfPlayer) +str(lobbyList._listOfPlayerConnected[i]._playerName) + "\n"
	return listOfPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
class LobbyList:
	var _listOfPlayerConnected = {} #key : id   value : Player
	func _append_player(id,player):
		_listOfPlayerConnected[id] = player
	func _remove_player(id):
		_listOfPlayerConnected.erase(id)
	func _return_player_from_id(id):
		return self._listOfPlayerConnected[id]

class Player :
	var _playerId
	var _playerName
	var _playerGameInstanceId
	var _playing = false
	var _pv
	func _init(playerName, playerid):
		self._playerName = playerName
		self._playerId= playerid
	func return_player_id():
		return _playerId
	func return_player_name():
		return _playerName
	func return_player_game_id():
		return _playerGameInstanceId
