extends CharacterBody3D

@onready var input := %InputComponent
@onready var movement := %MovementComponent
@onready var camera: CameraComponent = %CameraComponent

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	input.tick()
	movement.dir = input.inputDir
	movement.jump = input.wantsJump
	movement.sprint = input.wantsSprint
	movement.tick(delta)
	camera.tick(delta)
	if input.wantsQuit:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	camera.input_tick(event)
