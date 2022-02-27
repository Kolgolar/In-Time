extends Node2D

const _MAX_TIME : float = 86400.0
const _DROP_TARGER_Q := 4

var _curr_time : float = _MAX_TIME - 120
var _stop_timer := false
var _curr_drop_q := 0

onready var _GameOverLabel = $UI/MainContainer/GameOver
onready var _Player = $Player
onready var _TimeLabel = $UI/MainContainer/Time
onready var _DropLabel = $UI/MainContainer/Drop
onready var _DropAnim = $UI/MainContainer/Drop/AnimationPlayer
onready var _EndingAnim = $UI/LateScreen/AnimationPlayer


func _ready():
	randomize()
	_update_drop_displaying()


func _process(delta):
	if not _stop_timer:
		_curr_time += delta
		if _curr_time < _MAX_TIME:
			_update_timer()
		else:
			_midnight()


func _input(event):
	if event.is_action_pressed("ui_restart"):
		_restart()


func get_player() -> Node2D:
	return _Player


func _time_up() -> void:
	_EndingAnim.play("youfool")
	_Player.hide_ui()


func _drop_picked_up() -> void:
	_curr_drop_q += 1
	_DropAnim.play("pickup")
	_update_drop_displaying()


func _update_drop_displaying() -> void:
	_DropLabel.text = "{0}/{1}".format({"0" : _curr_drop_q, "1" : _DROP_TARGER_Q})
	


func _update_timer() -> void:
	var hours := 0
	var minutes := 0
	var seconds := 0
	
	hours = _curr_time / 3600
	minutes = (_curr_time - hours * 3600) / 60
	seconds = _curr_time - hours * 3600 - minutes * 60
	
	var str_hours = str(hours)
	var str_minutes = str(minutes)
	var str_seconds = str(seconds)
	
	if str_seconds.length() == 1:
		str_seconds = "0" + str_seconds
	
	var time_str = "{0}:{1}:{2}".format({"0" : str_hours, "1" : str_minutes, "2" : str_seconds})
	_TimeLabel.text = time_str
	

func _midnight() -> void:
	_stop_timer = true
	_TimeLabel.text = "00:00:00"
	_time_up()
	

func _win() -> void:
	_Player.hide_ui()
	_stop_timer = true
	_EndingAnim.play("win")
	


func _restart() -> void:
	get_tree().reload_current_scene()


func _on_Restart_pressed():
	_restart()


func _on_Player_death():
	_GameOverLabel.show()


func _on_Player_drop_picked_up():
	_drop_picked_up()


func _on_EndTrigger_area_entered(area):
	if area.is_in_group("player"):
		if _curr_drop_q == _DROP_TARGER_Q:
			_win()
