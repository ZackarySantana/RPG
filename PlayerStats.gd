extends Node

# ========= Cooldowns ==========

const SWORD_ATTACK_COOLDOWN = 0.1
const SWORD_ATTACK_ALL_COOLDOWN = 0.5

const ROLL_COOLDOWN = 0.25

# ========== Attacks ==========

const ATTACKS = ["sword_attack", "sword_attack_all"]

# ========== Movement ==========

export var max_speed = 80
export var acceleration = 500
export var friction = 500
export var knockback = 100

# ========== Health ==========

export var max_health = 4 setget set_max_health
onready var health = max_health setget set_health

signal no_health
signal changed_health(value)
signal changed_max_health(value)

func set_health(value):
	health = value
	emit_signal("changed_health", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("changed_max_health", max_health)
