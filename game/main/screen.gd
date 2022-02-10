extends Node2D

var std_resolution : Vector2
var window_resolution : Vector2
var game_resolution : Vector2
var min_pos : Vector2 setget , _get_min_pos
var max_pos : Vector2 setget , _get_max_pos
var timer : Timer


func _ready():
	reload()
#	timer = Timer.new()
#	timer.connect("timeout", self, "fuck")
#	add_child(timer)
#	timer.start()
#
#
#
#func fuck():
#	_set_size_values()
#	_update_min_max_pos()
#	print_resolutions()


func reload() -> void:
	_set_size_values()
	_update_min_max_pos()
	print_resolutions()


func print_resolutions() -> void:
	print("Standard resolution: " + str(std_resolution.x) + " x " + str(std_resolution.y))
	print("Game resolution: " + str(game_resolution.x) + " x " + str(game_resolution.y))
	print("Window resolution: " + str(window_resolution.x) + " x " + str(window_resolution.y))
	print("------------------------------------")
	

func _set_size_values() -> void:
	std_resolution = Vector2(1920, 1080)
	game_resolution = get_viewport_rect().size
	window_resolution = OS.get_window_size()


func _update_min_max_pos() -> void:
	var ctrans = get_canvas_transform()
	min_pos = -ctrans.get_origin() / ctrans.get_scale()
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	max_pos = min_pos + view_size


func _get_min_pos():
#	_update_min_max_pos() # dunno why I call this every time
	return min_pos


func _get_max_pos():
#	_update_min_max_pos()
	return max_pos
