extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
   $AnimationPlayer.play("turnMeRoundBaby")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if spinning:
		spin_factor += dt * max(1, log(spin_factor)) * 3
	else:
		spin_factor -= dt * (log(spin_factor) / 2 + 2)
	spin_factor = clamp(spin_factor, 0.5, 10)
	$AnimationPlayer.playback_speed = spin_factor
	if spinee:
		#var player_size = ((spinee.get_node("CollisionShape2D") as CollisionShape2D).shape as RectangleShape2D).extents * 2
		#var bottom_y = spinee.position.y + player_size.y
		#var spin_pos_pow = 1 - (position.y - bottom_y) / $Sprite.texture.get_height()
		#print(spin_pos_pow)
		spinee.accels.remove(spinee.accels.find(spin_vec))
		spin_vec.y = -spin_factor * 4 * dt
		#print(spin_factor)
		if spin_factor > 9:
			if spin_vec.y > 0:
				spin_vec.y *= -1
			spin_vec.y *= 1000
			spinee.yeet_timeout = 5
		spinee.accels.append(spin_vec)
		#print(spinee._acceleration + spin_vec)


var spinning = false
var spinee: Player
var spin_factor = 0.5
var spin_vec = Vector2(0, 0)

func _on_body_entered(body):
	if not body is Player: return
	body = body as Player
	spin_vec = Vector2(0, 0)
	body.accels.append(spin_vec)
	spinning = true
	spinee = body


func _on_body_exited(body):
	if not body is Player: return
	body = body as Player
	spinee.accels.remove(spinee.accels.find(spin_vec))
	spinning = false
	spinee = null
