extends KinematicBody2D

signal death

const _PROJECTILE_SPEED := 35
const _FIRING_SPEED = 20
const _PROJECTILE_SPREAD := 15

var _move_speed := 800
var _is_firing := false
var _move_vector := Vector2(0, 0)
var _firing_vector := Vector2(0, 0)
var _firing_timer_value : float
var _projectile_spread_rad : float = deg2rad(_PROJECTILE_SPREAD)

var _dead := false

onready var _DirJoy = $UI/MainContainer/DirJoy
onready var _FireJoy = $UI/MainContainer/FireJoy
onready var _FiringTimer = $FiringTimer
onready var _Projectile = $Projectile
onready var _ProjectilesContainer : Node


func _ready():
	_firing_timer_value = 1.0 / float(_FIRING_SPEED)
	var proj_cont = Node.new()
	get_parent().call_deferred("add_child", proj_cont)
	_ProjectilesContainer = proj_cont


func _physics_process(delta):
	if not _dead:
		_moving(delta)
		_config_firing()
		_pos_clamp()


func _moving(delta) -> void:
	_move_vector = _DirJoy.get_output()
	move_and_slide(_move_vector * _move_speed, Vector2.UP)


func _pos_clamp() -> void:
	var gp = global_position
	global_position = Vector2(clamp(gp.x, 0, Screen.game_resolution.x), clamp(gp.y, 0, Screen.game_resolution.y))


func _death():
	_dead = true
	emit_signal("death")
	queue_free()


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
	new_projectile.speed = _PROJECTILE_SPEED
	new_projectile.global_position = global_position
	var projectile_vector = _firing_vector.rotated(rand_range(-_projectile_spread_rad, _projectile_spread_rad))
	new_projectile.fire(projectile_vector)
	_ProjectilesContainer.add_child(new_projectile)
	_FiringTimer.start(_firing_timer_value)


func _on_FiringTimer_timeout():
	_config_firing()
	_fire()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if not area.get_parent().friendly:
			_death()
	elif area.is_in_group("enemies"):
		_death()
