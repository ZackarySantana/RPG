extends Area2D

onready var timer = $Timer

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

signal invincible_started
signal invincible_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincible_started")
	else:
		emit_signal("invincible_ended")

func start_invincible(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	get_tree().current_scene.add_child(hitEffect)
	hitEffect.global_position = global_position - Vector2(0, 8)

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincible_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invincible_ended():
	set_deferred("monitoring", true)
