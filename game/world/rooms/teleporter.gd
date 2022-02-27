extends Area2D


export (NodePath) var node_path

var tp_to : Node2D

func _ready():
	tp_to = get_node(node_path)


func _are_enemies_dead() -> bool:
	var potentials = $"../Enemies".get_children()
	for child in potentials:
		if child.is_in_group("enemies"):
			return false
	return true


func _on_Teleporter_area_entered(area):
	if area.is_in_group("player") and _are_enemies_dead():
		area.get_parent().tp_to(tp_to.global_position)
