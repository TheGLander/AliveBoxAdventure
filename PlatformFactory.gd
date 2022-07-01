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
	#print("Generating platform %d" % nextN)
	var new = res.instance() as GeneratedPlatform
	new.name = "Platform %d" % nextN
	new.position = last_platform_end
	new.position.x += rand_range(90, 120)
	new.platformN = nextN
	if (nextN + 1) % 13 == 0:
		new.set_save_platform(true)
	else:
		if randf() > 0.5:
			new.position.y += rand_range(0, 130)
		else:
			new.position.y += rand_range(0, -90)
		if randf() > pow(0.9, log(nextN) / log(1.25)):
			var max_rot = min(deg2rad(30), pow(1.1, nextN) - 1)
			new.rotation = rand_range(-max_rot, max_rot)
		if randf() > pow(0.9, log(nextN) / log(1.75)):
			new.set_cloudy(true)
		if randf() > pow(0.9, log(nextN) / log(4)):
			new.add_tornado()
		if randf() > pow(0.9, log(nextN) / log(8)):
			new.add_vines()
			#new.add_vine()
	#else:
	#	# Save platform
	#	#new.set_save_platform(true)
	new.position.y = clamp(new.position.y, 300, hell.position.y - 300)
	new.connect("platform_seen", self, "on_platform_seen")
	add_child(new)
	randomize()
	return new

export var PLATFORM_REMOVE_OFFSET: int = 3 - MAX_PLATFORMS

# Called when the node enters the scene tree for the first time.
func _ready():
	save.load_game()
	#print("Load")
	#print(save.save_platform)
	#print(save.save_platform_coords)
	var last: GeneratedPlatform
	last_platform_seen = save.save_platform
	var generator_offset = 0
	if  save.save_platform != 0:
		remove_child($"Platform 0")
		last = create_platform(save.save_platform_coords, save.save_platform)
		player.position = (last.position + last.get_platform_end()) / 2
		player.position.y -= 96
		generator_offset = save.save_platform + 1
	else:
		last = $'Platform 0'
	last.connect("platform_seen", self, "on_platform_seen")
	#print(last.position)
	for i in range(MAX_PLATFORMS):
		var next = create_platform(last.get_platform_end(), i + generator_offset)
		last = next

func replace_platform(toRemoveI: int):
	if has_node("Platform %d" % toRemoveI):
		var toRemove = (get_node("Platform %d" % toRemoveI)) as GeneratedPlatform
		remove_child(toRemove)
	var toAddI = toRemoveI + MAX_PLATFORMS
	if not has_node("Platform %d" % toAddI):
		 create_platform(get_node("Platform %d" % (toAddI - 1)).get_platform_end(), toAddI)
	

var last_platform_seen = 0

func on_platform_seen(platform: GeneratedPlatform):
	if platform.save_platform:
		(player.get_node("SaveAnimation/AnimationPlayer") as AnimationPlayer).play("checkpoint")
		save.save_platform = platform.platformN
		save.save_platform_coords = platform.get_platform_end()
		save.save_game()
	var toRemoveI = platform.platformN  + PLATFORM_REMOVE_OFFSET
	for to_remove in range(last_platform_seen + 1, toRemoveI + 1):
		replace_platform(to_remove)
	last_platform_seen = toRemoveI

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
