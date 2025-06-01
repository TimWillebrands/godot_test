extends AnimatedSprite2D

func _on_character_body_2d_is_moving() -> void:
	animation = "walking"

func _on_character_body_2d_is_idle() -> void:
	animation = "idle"

func _on_character_body_2d_dir_changed(is_going_left: bool) -> void:
	flip_h = not is_going_left
