extends CharacterBody2D

@export var speed = 800
@export var jump_speed = -800
@export var gravity = 5000
@export var max_jumps = 2
@export var coyote_time = 0.15  # Time in seconds to allow jumping after leaving platform

var coyote_timer = 0.0
var was_on_floor = false
var is_going_left = true
var jumps_remaining = max_jumps  # Track available jumps

signal is_moving
signal is_idle
signal dir_changed(is_going_left: bool)

func _physics_process(delta):
	velocity.y += gravity * delta

	velocity.x = Input.get_axis("left", "right") * speed

	move_and_slide()
	
	if velocity.x != 0:
		is_moving.emit()
	else:
		is_idle.emit()
	
	if velocity.x > 0 and is_going_left:
		is_going_left = false
		dir_changed.emit(is_going_left)
	if velocity.x < 0 and not is_going_left:
		is_going_left = true
		dir_changed.emit(is_going_left)

	# Update coyote timer
	if is_on_floor():
		coyote_timer = coyote_time
		was_on_floor = true
		jumps_remaining = max_jumps  # Reset jumps when landing
	elif was_on_floor:
		coyote_timer -= delta
		if coyote_timer <= 0:
			was_on_floor = false

	var jmp = Input.is_action_just_pressed("up")
	if jmp and ((is_on_floor() or coyote_timer > 0) or jumps_remaining > 0):
		velocity.y = jump_speed
		coyote_timer = 0  # Reset coyote time after jumping
		jumps_remaining -= 1  # Use up a jump
