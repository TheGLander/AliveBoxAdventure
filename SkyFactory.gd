extends ParallaxLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TOTAL_CLOUDS = 20
var createdClouds = false
onready var save = get_tree().root.get_node("Node2D/GameSave") as GameSave

func vec_in_rect(rect: Rect2):
	return rect.position + Vector2(
		rect.size.x * randf(),
		rect.size.y * randf()
	)

func rand_vec(vec: Vector2):
	return Vector2(vec.x * (randf() * 2 - 1), vec.y * (randf() * 2 - 1))

func to_vec2(vec: Vector3):
	return Vector2(vec.x, vec.y)

func _ready():
	seed(save.game_seed)
	for _i in range(TOTAL_CLOUDS):
		var cloud: Sprite =  Sprite.new()
		var texture = load("res://clouds/cloud%d.png" % (randi() % 5 + 1)) as StreamTexture
		cloud.texture = texture
		var cloudPos = vec_in_rect(Rect2(0, 0, 4000, 2048))
		cloud.position = cloudPos
		cloud.scale = Vector2(0.5, 0.5)
		self.add_child(cloud)
	randomize()

const CLOUD_SLIDE = deg2rad(-165)
const CLOUD_SPEED = 8
const CLOUD_SLIDE_OFFSET = Vector2(3, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i = 0
	for cloud in get_children():
		seed(save.game_seed + i)
		cloud.position += (Vector2(CLOUD_SPEED, 0).rotated(CLOUD_SLIDE) + rand_vec(CLOUD_SLIDE_OFFSET)) * delta
		i += 1
	randomize()
