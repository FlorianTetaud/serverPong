extends ViewportContainer

var previousGameViewer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var camera  = $Viewport/Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	var spinBoxValue = str($SpinBox.value)
	var game0 = get_tree().get_root().get_node("pong/Server/"+spinBoxValue)
	if(game0 and previousGameViewer):
		if(game0.name == previousGameViewer.name):
			pass
		else:
			game0.visible = true
			previousGameViewer.visible = false
	if(game0 and previousGameViewer == null):
		game0.visible = true
	previousGameViewer = game0
		
		#$ViewportContainer/Viewport.world_2d= game0.world_2d
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
