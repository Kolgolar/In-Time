extends KinematicBody2D

export var projectile_speed : int = 5
export var projectile_spawn_radius := 10
export var projectiles_quantity := 25
export var spawn_rot_time := 10.0
export var shots_per_sec := 10.0

var _spawn_rot_speed : float
var _firing_time_pause : float

onready var ProjectilesSpawner = $ProjectilesSpawner
onready var FiringTimer = $FiringTimer


func _ready():
	_spawn_rot_speed = deg2rad(360.0 / spawn_rot_time)
	_firing_time_pause = 1.0 / shots_per_sec
	fire()


func _process(delta):
	ProjectilesSpawner.rotate(_spawn_rot_speed * delta)


func fire() -> void:
	ProjectilesSpawner.fire(projectile_spawn_radius, projectiles_quantity, projectile_speed, false)
	FiringTimer.start(_firing_time_pause)


func _death() -> void:
	queue_free()


func _on_FiringTimer_timeout():
	fire()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if area.get_parent().friendly == true:
			_death()
	elif area.is_in_group("player"):
		_death()
