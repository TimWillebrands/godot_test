extends AnimatedSprite2D

func _ready():
	# Connect to the animation finished signal
	animation_finished.connect(_on_animation_finished)
	# Play the explosion animation
	play("explode")

func _on_animation_finished():
	# When animation is done, queue free the explosion
	queue_free()
