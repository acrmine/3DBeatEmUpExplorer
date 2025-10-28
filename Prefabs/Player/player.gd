extends RigidBody3D

var JUMP_VELOCITY := 20.0

var mouseSensitivity := 0.005
var twistInput = 0.0
var pitchInput = 0.0
var playerPrevPos := self.global_position
var playerCurrPos: Vector3
var playerPosOffst: Vector3
var jumpVector := Vector3.UP * JUMP_VELOCITY

@onready var playercamera := $"../TwistPivot/PitchPivot/Camera3D"
@onready var twist_pivot := $"../TwistPivot"
@onready var pitch_pivot := $"../TwistPivot/PitchPivot"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Grab current position in this frame and calculate offset
	playerCurrPos = self.global_position
	playerPosOffst = playerCurrPos - playerPrevPos
	
	# Calculate inputs into 3D force vector
	#var input := Vector3.ZERO
	#input.x = Input.get_axis("move_left", "move_right")
	#input.z = Input.get_axis("move_forward", "move_back")
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (twist_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply calculated input forces
	apply_central_force(direction *  1200.0 * delta)
	
	# Essentially parent these objects to the player without adding rotation
	playercamera.global_position += playerPosOffst
	twist_pivot.global_position += playerPosOffst
	
	if Input.is_action_just_pressed("jump"):
		apply_central_force(jumpVector)
	
	# Apply camera rotation if any was added
	twist_pivot.rotate_y(twistInput)
	pitch_pivot.rotate_x(pitchInput)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twistInput = 0.0
	pitchInput = 0.0
	
	# Stow Curr position for next frames Prev position
	playerPrevPos = playerCurrPos


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
	
	if event is InputEventKey and event.is_action_pressed("jump"):
		apply_central_force(jumpVector)
