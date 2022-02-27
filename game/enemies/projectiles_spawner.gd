extends Node2D

onready var _Projectile = $Projectile
onready var _ProjectilesContainer : Node


func _ready():
	$Projectile.hide()
	var proj_cont = Node.new()
	$"../../".call_deferred("add_child", proj_cont)
	_ProjectilesContainer = proj_cont


func fire1(direction : Vector2, radius : float, quantity : int, speed : int, is_friendly := false) -> void:
	var pos := (Vector2.UP * radius + global_position).normalized().rotated(global_rotation)
	var rot_step = deg2rad(360.0 / quantity)
	for i in quantity:
		_spawn_projectile(pos, speed, is_friendly)
		pos = pos.rotated(rot_step)

func fire_shotgun(to : Vector2, spread_angle : float, rnd_spread_add : float, quantity : int, speed : int, is_friendly := false) -> void:
	var curr_angle = -spread_angle / 2
	var rot_step : float = spread_angle / quantity
	
	var fly_vec = to.rotated(curr_angle)
	for i in quantity:
		var spread_add = rand_range(-rnd_spread_add, rnd_spread_add)
		_spawn_projectile(fly_vec.rotated(spread_add), speed, false)
		fly_vec = fly_vec.rotated(rot_step)



func _spawn_projectile(pos: Vector2, speed : int, is_friendly := false) -> void:
	var new_projectile = _Projectile.duplicate()
	new_projectile.friendly = is_friendly
	new_projectile.speed = speed
	_ProjectilesContainer.add_child(new_projectile) # add to node in main scene
	new_projectile.global_position = pos + global_position
	new_projectile.fire(pos.normalized())
	
