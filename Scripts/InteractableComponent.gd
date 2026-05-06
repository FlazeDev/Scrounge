class_name InteractableComponent
extends Node


func interact(_player:CharacterBody3D)->void:
	print("Interacted with " + get_parent().name)
