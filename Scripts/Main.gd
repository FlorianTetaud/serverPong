extends Node2D

var BALL_NODE = preload("../Scenes/Ball.tscn")
var ball = BALL_NODE.instance()

const DEFAULT_Y = 150

const p1_x = 15
var p1_y = DEFAULT_Y
var p1_score = 0

const p2_x = 975
var p2_y = DEFAULT_Y
var p2_score = 0

var playing = false
var score_event = false
var game_done = false

const SPACE_TO_PLAY = "Press SPACE to Play!"
const P1_WIN = "Player 1 won!"
const P2_WIN = "Player 2 won!"
var message = SPACE_TO_PLAY

var _player1Id
var _player2Id
# Called when the node enters the scene tree for the first time.

var KEY_UP_p1_pressed = false
var KEY_DOWN_p1_pressed= false
var KEY_UP_p2_pressed = false
var KEY_DOWN_p2_pressed= false

func _ready():
	set_ball()
	$Player1.set_paddle_position(p1_x, p1_y)
	$Player2.set_paddle_position(p2_x, p2_y)
	display_message()
	#update_score()


func init(playerid1,playerid2):
	KEY_UP_p1_pressed = playerid1
	_player2Id = playerid2
#func _input(_event):
#	if Input.is_key_pressed(KEY_SPACE):
#		get_node("Server")._server_input_event(_event)
#		#play()


func _process(delta):
	handle_movement_input(delta)
	$Player1.set_paddle_position(p1_x, p1_y)
	$Player2.set_paddle_position(p2_x, p2_y)
	check_point_scored()
	handle_score_event()
	handle_game_end()
	
func _on_Timer_timeout():
	var data = $Ball.get_ball_position()
	var dx = str(data.dx)
	var dy = str(data.dy)
	var playing = str(data.playing)
	get_parent()._return_server_ball_info(_player1Id,dx,dy,playing)
	get_parent()._return_server_ball_info(_player2Id,dx,dy,playing)
	get_parent()._return_players_position(_player1Id,p1_x,p1_y,p2_x,p2_y)
	get_parent()._return_players_position(_player2Id,p1_x,p1_y,p2_x,p2_y)
	
func play():
	if game_done: # if game was done, reset states to start a fresh game
		game_done = false
		p1_score = 0
		p2_score = 0
		message = SPACE_TO_PLAY
		update_score()
	playing = true
	ball.set_playing(playing)
	get_parent()._return_DisplayMessage(_player1Id," ","False")
	get_parent()._return_DisplayMessage(_player2Id," ","False")

func check_point_scored():
	if ball.position.x <= 0:
		score_event = true
		p2_score += 1
	if ball.position.x >= 1000:
		score_event = true
		p1_score += 1
	update_score()
	if p1_score == 5 or p2_score == 5:
		game_done = true

func set_control(playerid,KEY_UP_pressed,KEY_DOWN_pressed):
	if(playerid == _player2Id):
		KEY_UP_p1_pressed = KEY_UP_pressed
		KEY_DOWN_p1_pressed=KEY_DOWN_pressed
	else:
		KEY_UP_p2_pressed = KEY_UP_pressed
		KEY_DOWN_p2_pressed=KEY_DOWN_pressed


func handle_movement_input(delta):
	if (KEY_UP_p1_pressed):
		p1_y -= 300 * delta
	if (KEY_DOWN_p1_pressed):
		p1_y += 300 * delta
	if (KEY_UP_p2_pressed):
		p2_y -= 300 * delta
	if (KEY_DOWN_p2_pressed):
		p2_y += 300 * delta


func handle_score_event():
	if score_event:
		remove_ball()
		set_ball()
		reset_paddle_positions()
		display_message()
		playing = false
		score_event = false
		#$ScoreSound.play()


func remove_ball():
	remove_child(ball)


func set_ball():
	ball = BALL_NODE.instance()
	add_child(ball)


func reset_paddle_positions():
	p1_y = DEFAULT_Y
	p2_y = DEFAULT_Y


func update_score():
	get_parent()._return_score_info(_player1Id,str(p1_score),str(p2_score))
	get_parent()._return_score_info(_player2Id,str(p1_score),str(p2_score))

func handle_game_end():
	if game_done:
		if p1_score == 5:
			message = P1_WIN
		else:
			message = P2_WIN
		display_message()


func display_message():
	get_parent()._return_DisplayMessage(_player1Id,message,"true")
	get_parent()._return_DisplayMessage(_player2Id,message,"true")


