class_name InputComponent
extends Node

var inputDir := Vector2.ZERO
var wantsJump := false
var wantsQuit := false
var wantsSprint := false

func tick() -> void:
	inputDir = Input.get_vector("left", "right", "up", "down").normalized()
	wantsJump = Input.is_action_just_pressed("jump")
	wantsQuit = Input.is_action_just_pressed("quit")
	wantsSprint = Input.is_action_pressed("sprint")
