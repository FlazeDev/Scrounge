extends CharacterBody3D

@onready var input := %InputComponent
@onready var movement := %MovementComponent
@onready var camera: CameraComponent = %CameraComponent
@onready var interaction: InteractionComponent = $InteractionComponent
@onready var inventory: InventoryComponent = $InventoryComponent
@onready var health: HealthComponent = %HealthComponent
@onready var stamina: StaminaComponent = %StaminaComponent

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory.ready_tick()
	health.ready_tick()
	health.dead.connect(death_test)
	stamina.ready_tick()

func _physics_process(delta: float) -> void:
	input.tick()
	movement.dir = input.inputDir
	movement.jump = input.wantsJump
	movement.sprint = input.wantsSprint
	movement.dash = input.wantsDash
	interaction.interact = input.wantsInteract
	inventory.use = input.wantsUse
	inventory.swap = input.wantsSwap
	inventory.drop = input.wantsDrop
	inventory.tick()
	interaction.tick()
	movement.tick(delta)
	camera.tick(delta)
	health.tick()
	stamina.tick(delta)
	if input.wantsQuit:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	camera.input_tick(event)
	
func death_test():
	print("dead")
