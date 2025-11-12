extends RigidBody3D

var JUMP_VELOCITY := 400.0
var DIVE_VELOCITY := 600.0

var mouseSensitivity := 0.005
var twistInput = 0.0
var pitchInput = 0.0
var terrainNormal: Vector3

var touchingGround: bool = false
var diving: bool = false

@onready var player_mesh := $MeshInstance3D
@onready var player_camera := $"../TwistPivot/PitchPivot/Camera3D"
@onready var twist_pivot := $"../TwistPivot"
@onready var pitch_pivot := $"../TwistPivot/PitchPivot"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.contact_monitor = true
	self.max_contacts_reported = 20


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if touchingGround && get_contact_count() > 0:
		terrainNormal = state.get_contact_local_normal(0).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	touchingGround = false
	for node in get_colliding_bodies():
		if node.is_in_group("GroundObjects"):
			touchingGround = true
			break

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (twist_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply calculated input forces
	apply_central_force(direction *  1200.0 * delta)
	
	# Apply camera rotation if any was added
	twist_pivot.rotate_y(twistInput)
	pitch_pivot.rotate_x(pitchInput)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-60), 
		deg_to_rad(30)
	)
	twistInput = 0.0
	pitchInput = 0.0


# Fired whenever input is given to the game (currently used for mouse)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twistInput = -event.relative.x * mouseSensitivity
			pitchInput = -event.relative.y * mouseSensitivity
	
	if event is InputEventKey and event.is_action_pressed("jump") and touchingGround:
		apply_central_force(terrainNormal * JUMP_VELOCITY)
	
	if event is InputEventKey and event.is_action_pressed("dive") and !touchingGround:
		apply_central_force(Vector3.DOWN * DIVE_VELOCITY)
			
