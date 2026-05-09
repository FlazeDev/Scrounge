class_name MovementComponent
extends Node

var speed := 9.0
var sprintSpeed := 18.0
var gravityMultiplier := 3.0
var dir := Vector2.ZERO
var jumpVel := 17.0
var jump := false
var sprint := false
@export var body:CharacterBody3D
@export var camera : Camera3D
@export var stamina:StaminaComponent
var sprintCost = 1
var dash := false
var dashSpeed := 40
var dashCost = 20

func _ready() -> void:
	if not body:
		body = get_parent() as CharacterBody3D

func tick(delta: float) -> void:
	if not body:
		return
	var moveDir := (body.transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if dash && stamina.stamina > dashCost:
		var dashDir = -camera.global_transform.basis.z.normalized()
		body.velocity = dashDir * dashSpeed
		stamina.reduce(dashCost)
	elif sprint && stamina.stamina > sprintCost:
		body.velocity.x = moveDir.x * sprintSpeed
		body.velocity.z = moveDir.z * sprintSpeed
		stamina.reduce(sprintCost)
	else:
		body.velocity.x = moveDir.x * speed
		body.velocity.z = moveDir.z * speed

	if !body.is_on_floor():
		body.velocity += body.get_gravity() * gravityMultiplier * delta
	if body.is_on_floor() && jump:
		body.velocity.y = jumpVel
		jump = false

	body.move_and_slide()
