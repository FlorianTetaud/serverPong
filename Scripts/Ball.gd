extends RigidBody2D

var dx : int = 100
var dy : int= 0
var speed : int= 150
var y_range: int = 100
var playing : bool= false

class Ball_Data:
	var dx
	var dy 
	var speed 
	var y_range 
	var playing 

var _Ball_Data = Ball_Data.new()
	
func _ready():
	pass

func _process(delta):
	_Ball_Data.dx = self.position.x
	_Ball_Data.dy = self.position.y
	_Ball_Data.speed = speed
	_Ball_Data.y_range = y_range
	_Ball_Data.playing = playing

func _physics_process(delta):
	if playing:
		change_dy_on_wall_hit()
		self.rotation = 0
		self.linear_velocity = Vector2(dx, dy) * delta * speed


func _ball_hit_paddle(_body):
	dx *= -1
	dy = rand_range(-y_range, y_range)
	if speed < 300:
		speed += 5
	if y_range < 200:
		y_range += 5
	$PaddleHitSound.play()


func change_dy_on_wall_hit():
	if self.position.y <= 0:
		dy = rand_range(0, y_range)
	if self.position.y >= 600:
		dy = rand_range(-y_range, 0)

func set_playing(_playing):
	playing = _playing

func get_ball_position():
	return _Ball_Data
