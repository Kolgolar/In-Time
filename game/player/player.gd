extends KinematicBody2D

const PROJECTILE_SPEED := 35

var _move_speed := 800
var _is_firing := false
var _move_vector := Vector2(0, 0)
var _firing_vector := Vector2(0, 0)

onready var _DirJoy = $UI/MainContainer/DirJoy
onready var _FireJoy = $UI/MainContainer/FireJoy
onready var _FiringTimer = $FiringTimer
onready var _Projectile = preload("res://game/other/Projectile.tscn").instance()


func _ready():
	pass


func _physics_process(delta):
	_moving(delta)
	_config_firing()


func _moving(delta) -> void:
	_move_vector = _DirJoy.get_output()
	move_and_slide(_move_vector * _move_speed, Vector2.UP)


func _config_firing() -> void:
	_firing_vector = _FireJoy.get_output().normalized()
	if _firing_vector.length_squared() > 0:
		if not _is_firing:
			_fire()
	else:
		_is_firing = false
		_FiringTimer.stop()


func _fire() -> void:
	_is_firing = true
	var new_projectile = _Projectile.duplicate()
	new_projectile.speed = PROJECTILE_SPEED
	new_projectile.global_position = global_position
	new_projectile.fire(_firing_vector)
	get_parent().add_child(new_projectile)
	_FiringTimer.start()
	print("FIRREEEEEE!!!!!")


func _on_FiringTimer_timeout():
	_config_firing()
	_fire()
