extends KinematicBody2D

signal death
signal drop_picked_up

const _PROJECTILE_SPEED := 35
const _FIRING_SPEED = 3
const _PROJECTILE_SPREAD := 1
const _MAX_HP := 9
const _MAG_AMMO_COUNT := 24

var _move_speed := 800
var _is_firing := false
var _move_vector := Vector2(0, 0)
var _firing_vector := Vector2(0, 0)
var _firing_timer_value : float
var _projectile_spread_rad : float = deg2rad(_PROJECTILE_SPREAD)
var _ammo := 8
var _hp : int

var _dead := false

onready var _DirJoy = $UI/MainContainer/DirJoy
onready var _FireJoy = $UI/MainContainer/FireJoy
onready var _FiringTimer = $FiringTimer
onready var _Projectile = $Projectile
onready var _AnimSprite = $AnimatedSprite
onready var _ProjectilesContainer : Node
onready var _AmmoLabel : Label = $UI/MainContainer/Ammo
onready var _HB : ProgressBar = $HealthBar
onready var _AmmoAnim = $UI/MainContainer/Ammo/AnimationPlayer

onready var _ImmuneToTeleport : Timer = $ImmuneToTeleport


func _ready():
	_hp = _MAX_HP
	_HB.max_value = _MAX_HP
	_firing_timer_value = 1.0 / float(_FIRING_SPEED)
	var proj_cont = Node.new()
	get_parent().call_deferred("add_child", proj_cont)
	_ProjectilesContainer = proj_cont


func _process(delta):
	_set_ammo_label()
	_HB.value = _hp


func _physics_process(delta):
	if not _dead:
		_moving(delta)
		_config_firing()
#		_pos_clamp()


func tp_to(pos : Vector2) -> void:
	if _ImmuneToTeleport.is_stopped():
		global_position = pos
		_ImmuneToTeleport.start()


func hide_ui() -> void:
	_DirJoy.hide()
	_FireJoy.hide()
	_AmmoLabel.hide()


func _moving(delta) -> void:
	_move_vector = _DirJoy.get_output()
	move_and_slide(_move_vector * _move_speed, Vector2.UP)
	if _move_vector.length_squared() > 0:
		_AnimSprite.animation = "walk"
	else:
		_AnimSprite.animation = "idle"


func _ammo_pickup(area : Area2D) -> void:
	_ammo += _MAG_AMMO_COUNT
	_AmmoAnim.play("pickup")
	area.queue_free()


func _set_ammo_label() -> void:
	_AmmoLabel.text = "Патроны: " + str(_ammo)


func _pos_clamp() -> void:
	var gp = global_position
	global_position = Vector2(clamp(gp.x, 0, Screen.game_resolution.x), clamp(gp.y, 0, Screen.game_resolution.y))


func _damage() -> void:
	_hp -= 1
	if _hp <= 0:
		_death()


func _death():
	_dead = true
	emit_signal("death")
	hide()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _config_firing() -> void:
	_firing_vector = _FireJoy.get_output().normalized()
	if _firing_vector.length_squared() > 0:
		if not _is_firing:
			_fire()
	else:
		_is_firing = false
		_FiringTimer.stop()


func _fire() -> void:
	if _ammo > 0:
		_is_firing = true
		var new_projectile = _Projectile.duplicate()
		new_projectile.speed = _PROJECTILE_SPEED
		new_projectile.global_position = global_position
		var projectile_vector = _firing_vector.rotated(rand_range(-_projectile_spread_rad, _projectile_spread_rad))
		new_projectile.fire(projectile_vector)
		_ProjectilesContainer.add_child(new_projectile)
		_FiringTimer.start(_firing_timer_value)
		_ammo -= 1
	else:
		_AmmoAnim.play("empty")


func _on_FiringTimer_timeout():
	_config_firing()
	_fire()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if not area.get_parent().friendly:
			_damage()
	elif area.is_in_group("enemies"):
		_damage()
	elif area.is_in_group("drop"):
		emit_signal("drop_picked_up")
		area.queue_free()
	elif area.is_in_group("ammo"):
		_ammo_pickup(area)
