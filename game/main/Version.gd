extends Label


func _ready():
	text = "SOVOK v." + str(ProjectSettings.get_setting("application/config/version"))
