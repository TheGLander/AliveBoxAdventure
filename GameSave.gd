class_name GameSave
extends Node

var game_seed = randi()
var save_platform = 0
var save_platform_coords = Vector2(0, 0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json({
		"game_seed": game_seed,
		"save_platform": save_platform,
		"save_platform_coords": save_platform_coords
	}))
	save_game.close()

static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(array[0], array[1])

	return Vector2.ZERO

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		reset_game()
		return
	save_game.open("user://savegame.save", File.READ)
	var save = parse_json(save_game.get_as_text())
	game_seed = save.game_seed
	save_platform = save.save_platform
	save_platform_coords = string_to_vector2(save.save_platform_coords)
	save_game.close()

func reset_game():
	game_seed = randi()
	save_platform = 0
