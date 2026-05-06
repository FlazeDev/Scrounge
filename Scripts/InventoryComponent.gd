class_name  InventoryComponent
extends Node

var invSlots:Array[Node3D] = []
var usable : Node
@export var hand1:Node3D
var use := false
var swap := false

func init_tick() -> void:
	for i in 2:
		invSlots.append(null)

func tick() -> void:
	if use:
		use_item()
	if swap:
		_swap()

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
	if hand1.get_child_count() < 1:
		hand1.add_child(item)
	else:
		hand1.get_child(0).queue_free()
		hand1.add_child(item)
		

func _swap():
	if invSlots[1] != null:
		var tempSlot = invSlots[0].duplicate()
		invSlots[0] = invSlots[1].duplicate()
		invSlots[1] = tempSlot
		update_model(invSlots[0])
	else:
		print("nothing to swap")
