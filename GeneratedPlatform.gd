class_name GeneratedPlatform
extends StaticBody2D

signal platform_seen(platformN)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var platformN = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var touched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func collision(with):
	if not touched and with is Player:
		touched = true
		emit_signal("platform_seen", platformN)
