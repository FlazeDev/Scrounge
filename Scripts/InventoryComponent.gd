class_name  InventoryComponent
extends Node

var invSlots:Array[Node3D] = []
var usable : Node
@export var hand:Node3D
@export var dropPoint:Node3D
var use := false
var swap := false
var drop := false

func init_tick() -> void:
	for i in 2:
		invSlots.append(null)

func tick() -> void:
	if use:
		use_item()
	if swap:
		swap_item()
	if drop:
		drop_item()

func add_item(item:Node3D):
	if invSlots[0] == null:
		invSlots[0] = item.duplicate()
		update_model(invSlots[0])
		return true
	elif invSlots[1] == null:
		invSlots[1] = item.duplicate()
		return true
	print("no space")
	return false
	
func use_item():
	if invSlots[0] != null:
		usable = invSlots[0].get_node("UsableComponent")
		usable.use()
	else:
		print("Nothing to use")
		
func update_model(item:Node):
	item.position = Vector3(0, 0, 0)
	if hand.get_child_count() < 1:
		hand.add_child(item)
	else:
		hand.get_child(0).queue_free()
		hand.add_child(item)
		
		

func swap_item():
	if invSlots[1] != null:
		var tempSlot = invSlots[0].duplicate()
		invSlots[0] = invSlots[1].duplicate()
		invSlots[1] = tempSlot
		update_model(invSlots[0])
	else:
		print("nothing to swap")
		
func drop_item():
	if invSlots[0] != null:
		invSlots[0] = invSlots[1]
		invSlots[1] = null
		var temp = hand.get_child(0).duplicate()
		hand.get_child(0).queue_free()
		get_tree().current_scene.add_child(temp)
		temp.global_position = dropPoint.global_position
		if invSlots[0] != null:
			update_model(invSlots[0])
