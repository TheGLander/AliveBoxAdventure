extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anim_offet = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if pushee != null:
		pushee.accels.remove(pushee.accels.find(spin_vec))
		pushee.yeet_timeout = 5
		spin_vec = Vector2(-1000, -1)
		pushee.accels.append(spin_vec)
	anim_offet += dt * 3
	$Sprite.scale.x = sin(anim_offet)
	$Area2D.scale.x = sin(anim_offet)

var spin_vec = Vector2(0, 0)
var pushing = false
var pushee: Player = null

func _on_body_entered(body):
	if not body is Player: return
	body = body as Player
	spin_vec = Vector2(0, 0)
	body.accels.append(spin_vec)
	pushee = body


func _on_body_exited(body):
	if not body is Player: return
	body = body as Player
	pushee.accels.remove(pushee.accels.find(spin_vec))
	pushee = null
