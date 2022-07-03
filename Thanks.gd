extends Control

onready var save = $GameSave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_TotalResetButton_pressed():
	save.reset_game()
	save.save_game()
	get_tree().change_scene("res://rootScene.tscn")


func _on_GoBackButton_pressed():
	get_tree().change_scene("res://rootScene.tscn")
