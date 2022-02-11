extends Node2D


onready var GameOverLabel = $UI/MainContainer/GameOver


func _ready():
	randomize()


func _input(event):
	if event.is_action_pressed("ui_restart"):
		_restart()


func _restart() -> void:
	get_tree().reload_current_scene()


func _on_Restart_pressed():
	_restart()


func _on_Player_death():
	GameOverLabel.show()
