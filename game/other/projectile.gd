extends KinematicBody2D

export var can_be_destruct := true

var friendly := true
var speed := 100

var _fly_direction := Vector2(0, 0)
var _should_move := false


func _physics_process(delta):
	if _should_move:
		move_and_collide(_fly_direction * speed)


func fire(direction) -> void:
	show()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	_should_move = true
	_fly_direction = direction


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if can_be_destruct and area.get_parent().friendly != friendly:
			queue_free()
	else:
		if friendly:
			if area.is_in_group("enemies"):
				queue_free()
		else:
			if area.is_in_group("player"):
				queue_free()
