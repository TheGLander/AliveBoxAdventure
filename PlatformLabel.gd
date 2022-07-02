extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var platform_factory = get_parent().get_parent().get_node("Game/PlatformFactory")
	platform_factory.platform_label = self
	platform_factory.update_platform_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
