extends CharacterBody2D

@export var speed = 800
@export var jump_speed = -800
@export var gravity = 5000

signal is_moving
signal is_idle

func _physics_process(delta):
	# Add gravity every frame
	velocity.y += gravity * delta

	# Input affects x axis only
	velocity.x = Input.get_axis("left", "right") * speed

	move_and_slide()
	
	if(velocity.x == 0):
		is_moving.emit()
	else:
		is_idle.emit()

	# Only allow jumping when on the ground
	var jmp = Input.is_action_just_pressed("up")
	if jmp and is_on_floor():
		velocity.y = jump_speed
