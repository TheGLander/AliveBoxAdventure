extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var touched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func collision(with):
	if not touched and with is Player:
		touched = true
		if get_parent().has_method("collision"):
			get_parent().collision(with)
