extends AnimatedSprite2D

func _on_character_body_2d_is_moving() -> void:
	animation = "idle"

func _on_character_body_2d_is_idle() -> void:
	animation = "walking"
