extends Label


func _ready():
	text = "In Time v." + str(ProjectSettings.get_setting("application/config/version"))
