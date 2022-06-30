class_name GeneratedPlatform
extends Node2D

signal platform_seen(platformN)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var platformN = 0

var cloudy = false
var save_platform = false

func set_cloudy(new_cloudy):
	cloudy = new_cloudy
	$EvilCloud.visible = cloudy
	$Platform2DBody.platform_friction_coef = 0.01 if cloudy else 0.1

func set_save_platform(new_save_platform):
	save_platform = new_save_platform
	$RainbowSprite.visible = save_platform

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var touched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func collision(with):
	if not touched and with is Player:
		touched = true
		emit_signal("platform_seen", self)
