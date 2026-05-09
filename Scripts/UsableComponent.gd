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
	
	
func use(_player:CharacterBody3D):
	var health = _player.get_node("HealthComponent")
	if health != null:
		var healOrDeal := randi_range(1, 2)
		if healOrDeal == 2:
			health.damage(20)
		else:
			health.heal(20)
