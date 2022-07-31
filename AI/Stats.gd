extends Node

# ========== Movement ==========

export var max_speed = 50
export var acceleration = 100
export var friction = 200

export var knockback = 160
export var wander_range = 10

# ========== Health ==========

export var max_health = 1
onready var health = max_health setget set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
