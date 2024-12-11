extends RigidBody3D


var is_powering_up_shot: bool = false
var shot_power: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_powering_up_shot:
		shot_power += delta
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT):
		if event.is_pressed():
			is_powering_up_shot = true
			shot_power = 0.0
		else:
			is_powering_up_shot = false


func get_shot_power() -> float:
	return shot_power


func hit_ball(direction: Vector3) -> void:
	apply_impulse(direction * shot_power)
	pass


func _on_timer_timeout() -> void:
	gravity_scale = 1
	pass # Replace with function body.
