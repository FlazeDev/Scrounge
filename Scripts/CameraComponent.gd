class_name CameraComponent
extends Node

var mouseSens := 0.01
@export var cam : Camera3D
@export var body : CharacterBody3D
@export var head : Node3D
var rotationSpeed := 12

var bobFreq := 2.0
var bobAmp := 0.08
var tBob := 0.0

func input_tick(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		body.rotate_y(-event.relative.x * mouseSens)
		head.rotate_x(-event.relative.y * mouseSens)
		head.rotation.x = clamp(cam.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
		
func tick(delta:float) -> void:
	tBob += delta * body.velocity.length() * float(body.is_on_floor())
	head.transform.origin = headbob(tBob)
	
func headbob(time:float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = sin(time * bobFreq) * bobAmp
	return pos
