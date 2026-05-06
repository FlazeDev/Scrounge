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
var camera : Camera3D

func _ready() -> void:
	if not body:
		body = get_parent() as CharacterBody3D

func tick(delta: float) -> void:
	if not body:
		return
	var moveDir := (body.transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if !sprint:
		body.velocity.x = moveDir.x * speed
		body.velocity.z = moveDir.z * speed
	elif sprint:
		body.velocity.x = moveDir.x * sprintSpeed
		body.velocity.z = moveDir.z * sprintSpeed



	if !body.is_on_floor():
		body.velocity += body.get_gravity() * gravityMultiplier * delta
	if body.is_on_floor() && jump:
		body.velocity.y = jumpVel
		jump = false


	#print(jump)
	body.move_and_slide()
