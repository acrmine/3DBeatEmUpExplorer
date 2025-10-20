extends RigidBody3D

var playerPrevPos := self.global_position
var playerCurrPos: Vector3
var playerPosOffst: Vector3

@onready var playercamera := $"../Camera3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Grab current position in this frame and calculate offset
	playerCurrPos = self.global_position
	playerPosOffst = playerCurrPos - playerPrevPos
	
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(input *  1200.0 * delta)
	playercamera.global_position += playerPosOffst
	
	# Stow Curr position for next frames Prev position
	playerPrevPos = playerCurrPos
