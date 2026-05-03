class_name InputComponent
extends Node

var inputDir := Vector2.ZERO
var wantsJump := false

func tick() -> void:
	inputDir = Input.get_vector("left", "right", "up", "down").normalized()
	wantsJump = Input.is_action_just_pressed("jump")
