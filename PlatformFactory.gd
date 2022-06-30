class_name PlatformFactory
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MAX_PLATFORMS = 10

onready var res = load("res://GeneratedPlatform.tscn") as Resource
onready var hell = get_tree().root.get_node("Node2D/ParallaxBackground/HellLayer/Hell") as Sprite
onready var save: GameSave = get_parent().get_node("GameSave")
onready var player = get_parent().get_node("Player") as Player

func create_platform(last_platform_end: Vector2, nextN: int):
	seed(save.game_seed + nextN)
	var new = res.instance() as GeneratedPlatform
	new.name = "Platform %d" % nextN
	new.position = last_platform_end
	new.position.x += rand_range(90, 120)
	new.platformN = nextN
	if (nextN + 1) % 13 != 0:
		if randf() > 0.5:
			new.position.y += rand_range(0, 130)
		else:
			new.position.y += rand_range(-90, 0)
		if randf() > pow(0.9, nextN):
			var max_rot = min(deg2rad(30), pow(1.1, nextN) - 1)
			new.rotation = rand_range(-max_rot, max_rot)
		if randf() > pow(0.9, nextN):
			new.set_cloudy(true)
	else:
		# Save platform
		new.set_save_platform(true)
	new.position.y = clamp(new.position.y, 130, hell.position.y - 130)
	new.connect("platform_seen", self, "on_platform_seen")
	add_child(new)
	randomize()
	return new

func get_platform_end(plat: GeneratedPlatform):
	var size = (plat.get_node("Platform2DBody/CollisionShape2D").shape as RectangleShape2D).extents * 2
	var platEnd = size.x * Vector2(cos(plat.rotation), sin(plat.rotation))
	return plat.position + platEnd

export var PLATFORM_REMOVE_OFFSET: int = 3 - MAX_PLATFORMS

# Called when the node enters the scene tree for the first time.
func _ready():
	save.load_game()
	print(save.game_seed)
	var last: GeneratedPlatform
	var generator_offset = 0
	if  save.save_platform != 0:
		remove_child($"Platform 0")
		last = create_platform(save.save_platform_coords, save.save_platform)
		player.position = (last.position + get_platform_end(last)) / 2
		player.position.y -= 96
		generator_offset = save.save_platform + PLATFORM_REMOVE_OFFSET + 1
	else:
		last = $'Platform 0'
	last.connect("platform_seen", self, "on_platform_seen")
	#print(last.position)
	for i in range(MAX_PLATFORMS):
		var next = create_platform(get_platform_end(last), i + generator_offset)
		last = next


func on_platform_seen(platform: GeneratedPlatform):
	print(platform.save_platform)
	var toRemoveI = platform.platformN + PLATFORM_REMOVE_OFFSET
	if platform.save_platform:
		(player.get_node("SaveAnimation/AnimationPlayer") as AnimationPlayer).play("checkpoint")
		save.save_platform = platform.platformN
		save.save_platform_coords = get_platform_end(platform)
		save.save_game()
	if toRemoveI < 0: return
	var toRemove = (get_node("Platform %d" % toRemoveI)) as GeneratedPlatform
	var toAddI = toRemoveI + MAX_PLATFORMS
	var toAdd = create_platform(get_platform_end(get_node("Platform %d" % (toAddI - 1))), toAddI)
	remove_child(toRemove)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
