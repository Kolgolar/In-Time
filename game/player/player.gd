extends KinematicBody2D

var _move_vector := Vector2(0, 0)
var _move_speed := 800

onready var _DirJoy = $UI/MainContainer/DirJoy
onready var _FireJoy = $UI/MainContainer/FireJoy

func _ready():
	pass


func _physics_process(delta):
	_moving(delta)


func _moving(delta) -> void:
	_move_vector = _DirJoy.get_output()
	position += _move_vector * _move_speed * delta
