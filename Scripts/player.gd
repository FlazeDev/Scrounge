extends CharacterBody3D

@onready var input := %InputComponent
@onready var movement := %MovementComponent
@onready var camera: CameraComponent = %CameraComponent
@onready var interaction: InteractionComponent = $InteractionComponent
@onready var inventory: InventoryComponent = $InventoryComponent

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory.init_tick()

func _physics_process(delta: float) -> void:
	input.tick()
	movement.dir = input.inputDir
	movement.jump = input.wantsJump
	movement.sprint = input.wantsSprint
	interaction.interact = input.wantsInteract
	inventory.use = input.wantsUse
	inventory.swap = input.wantsSwap
	inventory.tick()
	interaction.tick()
	movement.tick(delta)
	camera.tick(delta)
	if input.wantsQuit:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	camera.input_tick(event)
