extends CharacterBody3D

@onready var input := %InputComponent
@onready var movement := %MovementComponent
@onready var camera: CameraComponent = %CameraComponent

func _physics_process(delta: float) -> void:
	input.tick()
	movement.dir = input.inputDir
	movement.jump = input.wantsJump
	movement.tick(delta)
	camera.tick(delta)

func _input(event: InputEvent) -> void:
	camera.input_tick(event)
