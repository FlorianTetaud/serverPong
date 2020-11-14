extends Control

var gameNode

func _ready():
	pass
	#update_score()

func init(playerid1,playerid2):
	gameNode = $ViewportContainer/Game_instance_viewport/Game
	gameNode._player1Id = playerid1
	gameNode._player2Id = playerid2

func set_control(playerid,KEY_UP_pressed,KEY_DOWN_pressed):
	if(playerid == gameNode._player2Id):
		gameNode.KEY_UP_p1_pressed = KEY_UP_pressed
		gameNode.KEY_DOWN_p1_pressed=KEY_DOWN_pressed
	else:
		gameNode.KEY_UP_p2_pressed = KEY_UP_pressed
		gameNode.KEY_DOWN_p2_pressed=KEY_DOWN_pressed
		
func play():
	gameNode.play()
