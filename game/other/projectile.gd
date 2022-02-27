extends KinematicBody2D

const ROT_SPEED = 10

export var can_be_destruct := true

var friendly := true
var speed := 100

var _fly_direction := Vector2(0, 0)
var _should_move := false
var _rot_speed : int


func _ready():
	_rot_speed = deg2rad(ROT_SPEED)


func _physics_process(delta):
	if _should_move:
		move_and_collide(_fly_direction * speed)
#		rotation += (_rot_speed * delta)


func fire(direction) -> void:
	if friendly:
		$AnimatedSprite.animation = "player"
	else:
		$AnimatedSprite.animation = "enemy"
	show()
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	_should_move = true
	_fly_direction = direction


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("projectiles"):
		if can_be_destruct and area.get_parent().friendly != friendly:
			queue_free()
	else:
		if friendly:
			if area.is_in_group("enemies"):
				queue_free()
		else:
			if area.is_in_group("player"):
				queue_free()


func _on_Area2D_body_entered(body):
	if not body.is_in_group("enemy") and not body.is_in_group("player"):
		queue_free()
