class_name PlatformFactory
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MAX_PLATFORMS = 10

onready var res = load("res://GeneratedPlatform.tscn") as Resource
onready var hell = get_tree().root.get_node("Node2D/Game/ParallaxBackground/HellLayer/Hell") as Sprite
onready var save: GameSave = get_parent().get_parent().get_node("GameSave")
onready var player = get_parent().get_node("Player") as Player
onready var platform_label = get_parent().get_node("UI/Label")

func update_platform_label():
	if last_platform_seen == 250:
		platform_label.text = "Platforms: 249.5 / 250"
	else:
		platform_label.text = "Platforms: %d / 250" % last_platform_seen

const SAVE_SPACING = 13

func create_platform(last_platform_end: Vector2, nextN: int):
	seed(save.game_seed + nextN)
	#print("Generating platform %d" % nextN)
	var new = res.instance() as GeneratedPlatform
	new = new as GeneratedPlatform
	new.name = "Platform %d" % nextN
	new.position = last_platform_end
	new.position.x += rand_range(90, 120)
	new.platformN = nextN
	if (nextN % 50 == 0 and nextN != 250) or nextN == 249:
		new.set_save_platform(true)
	if nextN == 50 or nextN == 100 or nextN == 150:
		if nextN > save.save_platform: new.add_reward()
	if nextN == 200:
		if nextN > save.save_platform: new.add_altar()
	if nextN == 250:
		new.add_exit()
	if nextN % SAVE_SPACING == 0:
		new.set_save_platform(true)
	if not (new.save_platform or new.exit_portal):
		if randf() > 0.5:
			new.position.y += rand_range(0, 130)
		else:
			new.position.y += rand_range(0, -90)
		var platform_hardness = 0
		if nextN > SAVE_SPACING * 5 and randf() > pow(0.8, log(nextN) / log(4)):
			new.add_tornado()
			platform_hardness += 2
		if nextN > SAVE_SPACING * 8 and randf() > pow(0.8, log(nextN) / log(6)):
			new.add_vines()
			platform_hardness += 3
		if nextN > SAVE_SPACING * 1 and randf() > pow(0.85, log(nextN) / log(1.25)):
			var max_rot = min(deg2rad(30), pow(1.1, nextN) - 1)
			new.rotation = rand_range(-max_rot, max_rot * pow(0.85, platform_hardness))
		if nextN > SAVE_SPACING * 3 and randf() > pow(0.9, log(nextN) / log(2)):
			new.set_cloudy(true)
	#else:
	#	# Save platform
	#	#new.set_save_platform(true)
	#print(new.position)
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
	var generator_offset = 1
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
		if i + generator_offset > 250: break
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
	if platform.reward:
		platform.get_node("Reward").collect()
	if platform.altar:
		platform.get_node("Altar").start_sacrifice()
	if platform.save_platform and platform.platformN != save.save_platform:
		(player.get_node("SaveAnimation/AnimationPlayer") as AnimationPlayer).play("checkpoint")
		save.save_platform = platform.platformN
		save.save_platform_coords = platform.get_platform_end()
		save.save_game()
	var toRemoveI = platform.platformN  + PLATFORM_REMOVE_OFFSET
	for to_remove in range(last_platform_seen + PLATFORM_REMOVE_OFFSET + 1, toRemoveI + 1):
		if to_remove + MAX_PLATFORMS > 250: break
		replace_platform(to_remove)
	last_platform_seen = platform.platformN
	update_platform_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
