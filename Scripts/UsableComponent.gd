class_name UsableComponent
extends InteractableComponent

var inventory:InventoryComponent

func interact(_player:CharacterBody3D):
	inventory = _player.get_node("InventoryComponent")
	if inventory != null:
		pickup(inventory)
	
func pickup(inv:InventoryComponent):
	if inv.add_item(get_parent()):
		get_parent().queue_free()
	
	
func use():
	print(get_parent().name + " used")
