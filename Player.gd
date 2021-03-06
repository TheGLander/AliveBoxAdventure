class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 120.0
const VELOCITY_EPSILON = 5.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
#onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
#onready var sound_jump = $Jump

onready var last_on_floor = false

var yeet_timeout = 0
# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(dt):
	# Play jump sound
	#if Input.is_action_just_pressed("jump" + action_suffix) and is_on_floor():
	#	sound_jump.play()

	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	calculate_move_velocity(direction, is_jump_interrupted, dt)

	var snap_vector = Vector2.ZERO
	if direction.y == 0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)
	#var do_anti_slide = false
	frictionCoef = 0.1
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		if collider.has_method("collision"):
			collider.collision(self)
		#var angle = -collision.get_angle(FLOOR_NORMAL)
		#var expected_speed = sin(angle) * gravity * dt / frictionCoef
		#print("Vg = %s;V = %s;Vgx = %s" % [gravity * dt, _velocity.x, expected_speed])
		#if  direction.x == 0 and abs(_velocity.x - expected_speed) < 20:
		#	do_anti_slide = true
		if "platform_friction_coef" in collider:
			frictionCoef = collider.platform_friction_coef
		else:
			frictionCoef = 0.1
	#if do_anti_slide:
	#	_velocity.x = 0
	# When the character???s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	var x_controller = direction.x if direction.x != 0 else _velocity.x
	if x_controller != 0:
		if x_controller > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
	animation_player.play(get_animation())

func get_animation():
	if abs(_velocity.x) > 20:
		return "moving"
	return "idle"

func get_direction():
	return Vector2(
		Input.get_action_strength("right" + action_suffix) - Input.get_action_strength("left" + action_suffix),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
	)


var frictionCoef = 0.1
var accels: Array = []

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		direction,
		is_jump_interrupted,
		dt
):
	if is_on_floor() and direction.x == 0 and _acceleration.x == 0:
		_velocity.x 
	_velocity.x *= (1 - frictionCoef)
	_acceleration.x = speed.x * frictionCoef * direction.x
	_acceleration.y = gravity * dt
	for accel in accels:
		_acceleration += accel
	_velocity.x += _acceleration.x
	_velocity.y += _acceleration.y
	#if (abs(_velocity.x) < VELOCITY_EPSILON):
	#	_velocity.x = 0
	#print(_velocity.x)
	if direction.y != 0.0:
		_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		_velocity.y *= 0.6
	return _velocity


func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new

onready var hell = get_tree().root.get_node("Node2D/Game/ParallaxBackground/HellLayer/Hell") as Sprite

func _process(delta):
	if position.y > hell.position.y:
		get_tree().reload_current_scene()
	if yeet_timeout > 0:
		yeet_timeout -= delta
	if yeet_timeout > 0 and position.y < -$CollisionShape2D.shape.extents.y * 2:
		get_tree().reload_current_scene()
