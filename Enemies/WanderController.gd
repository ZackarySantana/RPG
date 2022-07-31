extends Node2D

onready var timer = $Timer
onready var stats = get_parent().get_node("Stats")

onready var START_POSITION = global_position
onready var TARGET_POSITION = get_random_target()

func get_random_target():
	return Vector2(rand_range(-stats.wander_range, stats.wander_range), rand_range(-stats.wander_range, stats.wander_range))

func update_target_position():
	var target_vector = get_random_target()
	TARGET_POSITION = START_POSITION + target_vector

func time_left():
	return timer.time_left
	
func start(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
