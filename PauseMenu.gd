extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var resume_button = $ColoredBox/CenterContainer/CenterContainer/Resume
onready var confirm_dialog = $ColoredBox/CenterContainer/ConfirmationDialog
onready var save = get_parent().get_parent().get_node("GameSave") as GameSave

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	show()
	resume_button.grab_focus()

func close():
	hide()
#	resume_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Resume_pressed():
	hide()
	var tree = get_tree()
	tree.paused = not tree.paused


func _on_Reset_pressed():
	hide()
	var tree = get_tree()
	tree.paused = not tree.paused
	get_tree().reload_current_scene()


func _on_TotalReset_pressed():
	confirm_dialog.popup_centered()


func _on_ConfirmationDialog_confirmed():
	save.reset_game()
	save.save_game()
	hide()
	var tree = get_tree()
	tree.paused = not tree.paused
	get_tree().reload_current_scene()
