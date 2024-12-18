class_name MainCamera extends Camera3D

@export var target: Node3D
@export var lerp_speed: float

		
func _physics_process(delta) -> void:
	global_position = global_position.lerp(target.global_position, lerp_speed)
	
