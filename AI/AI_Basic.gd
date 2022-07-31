extends KinematicBody2D

onready var playerDetection = $PlayerDetection
onready var stats = $Stats

onready var wanderController = $WanderController

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = [IDLE, WANDER][randi() % 2]
var velocity = Vector2.ZERO

func do_state(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
			seek_player()
			
			if wanderController.time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start(rand_range(1, 2))
		WANDER:
			seek_player()
			
			if wanderController.time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start(rand_range(1, 2))
				
			var direction = global_position.direction_to(wanderController.TARGET_POSITION)
			velocity = velocity.move_toward(direction * stats.max_speed, stats.acceleration * delta)
			
			if global_position.distance_to(wanderController.TARGET_POSITION) <= 3:
				state = IDLE
		CHASE:
			var player = playerDetection.player
			
			if player == null:
				state = IDLE
				return
			
			var direction = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(direction * stats.max_speed, stats.acceleration * delta)
	
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	return state_list[randi() % state_list.size()]
