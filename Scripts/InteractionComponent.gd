class_name InteractionComponent
extends Node

@export var iRay:RayCast3D
var interact
@export var player:CharacterBody3D
func tick()->void:
	if interact && iRay.get_collider() != null:
		if iRay.get_collider().has_node("InteractableComponent"):
			var interactable = iRay.get_collider().get_node("InteractableComponent")
			interactable.interact(player)
		elif iRay.get_collider().has_node("UsableComponent"):
			var interactable = iRay.get_collider().get_node("UsableComponent")
			interactable.interact(player)
