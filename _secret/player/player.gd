extends Node3D

@export_category("Looking Variables")
@export var sensitivity: float = 0.01
@export var follow_target: RigidBody3D

@export_category("Power!!!!")
@export var power: float = 10

@onready var pivot_point: Node3D = $pivot_point
@onready var aim_point: Node3D = $pivot_point/aim_point
@onready var label_3: Label = $Control/Label3


var is_rotating: bool = false
var prev_mouse_position
var next_mouse_position
var prev_z_rotation: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# FOLLOW BALL
	if follow_target:
		position = follow_target.position
	
	# ROTATE CAMERA AROUND PIVOT POINT
	#pivot_point.rotate()
	
	if is_rotating:
		next_mouse_position = get_viewport().get_mouse_position()
		pivot_point.rotate_y(-(next_mouse_position.x - prev_mouse_position.x) * sensitivity * delta)
		pivot_point.rotate_object_local(Vector3.RIGHT ,-(next_mouse_position.y - prev_mouse_position.y) * sensitivity * delta)
		pivot_point.rotate_z(0.0)
		prev_mouse_position = next_mouse_position
		#pivot_point.rotate_z((pivot_point.rotation.z - prev_z_rotation) * sensitivity * delta)
		#prev_z_rotation = pivot_point.rotation.z
	
	if follow_target:
		label_3.text = "%.3f" % follow_target.get_shot_power()

func _input(event: InputEvent) -> void:
	
	if is_rotating and event is InputEventMouseMotion:
		#mouse_motion = event
		#print(event)
		pass
		
	
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT):
		if event.is_pressed():
			is_rotating = true
			prev_mouse_position = get_viewport().get_mouse_position()
			print("prev_mouse_position : ", prev_mouse_position)
		else:
			is_rotating = false
	
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT) \
			and event.is_released():
		follow_target.hit_ball((aim_point.global_position - pivot_point.global_position) * power)
		pass
	if event is InputEventKey and (event.keycode == KEY_ESCAPE) :

		get_tree().quit() 
