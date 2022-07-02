class_name Reward
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$RewardSprite.texture = load("res://reward/reward%d.png" % (save.rewards_gotten + 1))

func anim_progress():
	return $AnimationPlayer.current_animation_position / $AnimationPlayer.current_animation_length

func spin_mult():
	return 1 - 0.85 * anim_progress()

var rotate_offset = 0
var collected = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not collected: return
	rotate_offset += delta * spin_mult()
	$RewardSprite.scale.x = sin(rotate_offset * 30)

onready var save = get_tree().root.get_node("Node2D/GameSave") as GameSave

func collect():
	if collected: return
	collected = true
	$AnimationPlayer.play("collect")

func _on_Area2D_body_entered(body):
	if not body is Player: return
	collect()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		save.rewards_gotten += 1
		var platform = get_parent()
		if platform is GeneratedPlatform:
			platform = platform as GeneratedPlatform
			save.save_platform = platform.platformN
			save.save_platform_coords = platform.position
		save.save_game()
		get_parent().remove_child(self)
