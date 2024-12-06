extends CharacterBody3D

# Movement variables
# @export var velocity = Vector3.ZERO
@export var initial_force = 10.0  # Base force for minimal drag distance
@export var max_force = 50.0  # Maximum force the player can apply
@export var friction = 1.5
@export var max_speed = 50.0

# Mouse interaction
var is_dragging = false
var drag_start_position = Vector2.ZERO  # 2D screen space
var current_force = initial_force
var aim_direction = Vector3.FORWARD  # Default direction

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		 # Start drag: record initial mouse position
		is_dragging = true
		drag_start_position = get_viewport().get_screen_transform() * get_viewport().get_mouse_position()
	elif Input.is_action_pressed("left_click") and is_dragging:
		# Update aiming direction and force
		update_aim_and_force()
	elif Input.is_action_just_released("left_click") and is_dragging:
		# Release drag: apply velocity based on aim and force
		is_dragging = false
		velocity = aim_direction.normalized() * current_force
	
	if velocity.length() > 0:
		 # Move the ball and handle collision redirection
		move_and_slide()
		apply_friction(delta)

# Updates the aiming direction and force based on mouse movement
func update_aim_and_force():
	var drag_current_position = get_viewport().get_screen_transform() * get_viewport().get_mouse_position()
	var drag_delta = drag_current_position - drag_start_position

	# Calculate horizontal aiming (left/right) based on X axis
	var horizontal_angle = deg_to_rad(drag_delta.x)
	var horizontal_rotation = Basis(Vector3.UP, horizontal_angle)
	aim_direction = horizontal_rotation.xform(Vector3.FORWARD)

	# Calculate force (up/down) based on Y axis
	current_force = clamp(initial_force + drag_delta.y / 10.0, initial_force, max_force)

# Reduces the velocity over time to simulate friction
func apply_friction(delta):
	velocity = velocity.move_toward(Vector3.ZERO, friction * delta)

# Handles redirection upon collision with surfaces
func _integrate_forces(state):
	if is_on_floor() or is_on_wall():
		var collision = get_last_slide_collision()
		if collision:
			var normal = collision.normal
			velocity = velocity.bounce(normal) * 0.8  # Retain some energy with bounce_factor
