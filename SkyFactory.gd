extends ParallaxLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TOTAL_CLOUDS = 20
var createdClouds = false

# Called when the node enters the scene tree for the first time.
func _process(_dt):
	if (not createdClouds):
		createdClouds = true
		createClouds()

func vec_in_rect(rect: Rect2):
	return rect.position + Vector2(
		rect.size.x * randf(),
		rect.size.y * randf()
	)

func to_vec2(vec: Vector3):
	return Vector2(vec.x, vec.y)

func createClouds():
	for _i in range(TOTAL_CLOUDS):
		var cloud: Sprite =  Sprite.new()
		var texture = load("res://clouds/cloud%d.png" % (randi() % 4 + 1)) as StreamTexture
		cloud.texture = texture
		var cloudPos = vec_in_rect(Rect2(0, 0, 4000, 2048))
		cloud.position = cloudPos
		cloud.scale = Vector2(0.5, 0.5)
		self.add_child(cloud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
