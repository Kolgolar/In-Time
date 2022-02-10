extends KinematicBody2D

var friendly := true
var speed := 100

var _fly_direction := Vector2(0, 0)
var _should_move := false


func _physics_process(delta):
	if _should_move:
		move_and_collide(_fly_direction * speed)


func fire(direction) -> void:
	_should_move = true
	_fly_direction = direction
