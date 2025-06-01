extends CharacterBody2D

@export var speed = 300  # Movement speed
@export var sight_range = 300  # How far the enemy can see the player
@export var back_off_range = 80  # How far the enemy will stay away from player
@export var boom_range = 65  # How close the enemy must be to player to explode

var player = null
var is_exploding = false

func _ready():
	# Find the player node when the enemy is ready
	player = get_tree().get_first_node_in_group("player")

func explode():
	if is_exploding:
		return
		
	is_exploding = true
	
	# Stop movement
	velocity = Vector2.ZERO
	
	# Hide the enemy sprite
	$AnimatedSprite2D.hide()
	
	# Instance the explosion scene
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	
	# Queue free the enemy after a short delay
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _physics_process(_delta):
	if is_exploding or player == null:
		return
		
	# Calculate distance to player
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# If player is within sight range, move towards them
	if distance_to_player <= sight_range and distance_to_player >= back_off_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Move the enemy
		move_and_slide()
		
		# Update sprite direction based on movement
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0

	# Check for explosion based on distance
	if distance_to_player <= boom_range:
		explode()
