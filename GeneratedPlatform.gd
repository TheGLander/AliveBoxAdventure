class_name GeneratedPlatform
extends Node2D

signal platform_seen(platformN)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var platformN = 0
var size = $Platform2DBody/CollisionShape2D.shape.extents * 2

var cloudy = false
var save_platform = false
var tornado = false
var vines = false

func set_cloudy(new_cloudy):
	cloudy = new_cloudy
	$EvilCloud.visible = cloudy
	$Platform2DBody.platform_friction_coef = 0.01 if cloudy else 0.1

func set_save_platform(new_save_platform):
	save_platform = new_save_platform
	$RainbowSprite.visible = save_platform

func get_platform_end():
	var to_place = Vector2(size.x, 0)
	to_place = to_place.rotated(rotation)
	return position + to_place

func add_tornado():
	tornado = true

	var tornado_ins = (load("res://Tornado.tscn") as Resource).duplicate(true).instance()
	add_child(tornado_ins)
	tornado_ins.position = Vector2(size.x / 2, 0)

func add_vines():
	vines = true

	var vines_ins = (load("res://Vines.tscn") as Resource).duplicate(true).instance()
	add_child(vines_ins)
	vines_ins.position = Vector2(size.x / 2, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var touched = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func collision(with):
	#print("%d -> %s to %s" % [platformN, touched, with is Player])
	if not touched and with is Player:
		touched = true
		emit_signal("platform_seen", self)
		print(rotation_degrees)
		print(get_platform_end() - position)
