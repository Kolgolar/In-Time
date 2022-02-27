extends KinematicBody2D

const _MAX_HP = 3

export var _projectile_speed : int = 7
export var _projectile_spread_angle : float = 180
export var _projectile_rnd_spread_add : float = 15
export var _projectiles_quantity : int = 4
export var _spawn_rot_time := 10.0
export var _shots_per_sec := 1
export var _drop_num := -1

var _spawn_rot_speed : float
var _firing_time_pause : float
var _should_fire := false
var _hp : int

var _Player : Node2D
var _Drop : Node2D = preload("res://game/enemies/enemy_drop.tscn").instance()

onready var _ProjectilesSpawner = $ProjectilesSpawner
onready var _FiringTimer = $FiringTimer
onready var _PlayerDetector : RayCast2D = $PlayerDetector
onready var _HB : ProgressBar = $HealthBar


func _ready():
	_hp = _MAX_HP
	_HB.max_value = _MAX_HP
	_Player = get_tree().get_nodes_in_group("player")[0]
	_projectile_spread_angle = deg2rad(_projectile_spread_angle)
	_spawn_rot_speed = deg2rad(360.0 / _spawn_rot_time)
	_projectile_rnd_spread_add = deg2rad(_projectile_rnd_spread_add)
	_firing_time_pause = 1.0 / _shots_per_sec


func _process(delta):
#	_ProjectilesSpawner.rotate(_spawn_rot_speed * delta)
	_HB.value = _hp


func _physics_process(delta):
	_update_raycast()


func fire() -> void:
	var player_pos : Vector2 =_Player.global_position
	var dir : Vector2 = global_position.direction_to(player_pos)
	_ProjectilesSpawner.fire_shotgun(dir, _projectile_spread_angle, _projectile_rnd_spread_add, _projectiles_quantity, _projectile_speed, false)
	_FiringTimer.start(_firing_time_pause)


func _spawn_drop() -> void:
	var new_drop = _Drop
	new_drop.get_child(1).frame = _drop_num
	get_parent().call_deferred("add_child", new_drop)
	new_drop.global_position = global_position


func _update_raycast() -> void:
	_PlayerDetector.look_at(_Player.global_position)
	if _PlayerDetector.is_colliding():
		var collider = _PlayerDetector.get_collider()
		if collider.is_in_group("player"):
			if not _should_fire:
				_should_fire = true
				fire()
		else:
			_should_fire = false


func _damage() -> void:
	_hp -= 1
	if _hp <= 0:
		_death()


func _death() -> void:
	if _drop_num != -1:
		_spawn_drop()
	queue_free()


func _on_FiringTimer_timeout():
	if _should_fire:
		fire()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if area.get_parent().friendly == true:
			_damage()
	elif area.is_in_group("player"):
		pass
