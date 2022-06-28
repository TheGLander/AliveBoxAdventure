class_name PlatformFactory
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MAX_PLATFORMS = 10

onready var res = load("res://GeneratedPlatform.tscn") as Resource
onready var hell = get_tree().root.get_node("Node2D/ParallaxBackground/HellLayer/Hell") as Sprite

func create_platform(last: GeneratedPlatform, nextN: int):
	var new = res.instance() as GeneratedPlatform
	var lastSize = (last.get_node("CollisionShape2D").shape as RectangleShape2D).extents * 2
	new.name = "Platform %d" % nextN
	new.position.x = last.position.x + lastSize.x + rand_range(90, 120)
	new.position.y = last.position.y
	new.platformN = nextN
	if randf() > 0.5:
		new.position.y += rand_range(0, 130)
	else:
		new.position.y += rand_range(-90, 0)
	new.position.y = clamp(new.position.y, 130, hell.position.y - 130)
	print(new.position)
	new.connect("platform_seen", self, "on_platform_seen")
	add_child(new)
	return new

# Called when the node enters the scene tree for the first time.
func _ready():
	var last = $'Platform 0'
	last.connect("platform_seen", self, "on_platform_seen")
	print(last.position)
	for i in range(MAX_PLATFORMS):
		var next = create_platform(last, i)
		last = next


func on_platform_seen(platformN: int):
	var toRemoveI = platformN - MAX_PLATFORMS + 3
	if toRemoveI < 0: return
	var toRemove = (get_node("Platform %d" % toRemoveI)) as GeneratedPlatform
	var toAddI = toRemoveI + MAX_PLATFORMS
	var toAdd = create_platform(get_node("Platform %d" % (toAddI - 1)), toAddI)
	remove_child(toRemove)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
