extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func anim_progress():
	return $AnimationPlayer.current_animation_position / $AnimationPlayer.current_animation_length

func spin_mult():
	return 1 - 2 * anim_progress()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not started: return
	rotate_offset += delta * spin_mult()
	$Reward1.scale.x = sin(rotate_offset * 30)
	$Reward2.scale.x = sin(rotate_offset * 30)
	$Reward3.scale.x = sin(rotate_offset * 30)

onready var save = get_tree().root.get_node("Node2D/GameSave") as GameSave

var started = false
var rotate_offset = 0

func start_sacrifice():
	if started: return
	started = true
	$AnimationPlayer.play("sacrifice")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "sacrifice":
		save.rewards_gotten += 1
		var platform = get_parent()
		if platform is GeneratedPlatform:
			platform = platform as GeneratedPlatform
			save.save_platform = platform.platformN
			save.save_platform_coords = platform.position
		save.save_game()
		get_parent().remove_child(self)
