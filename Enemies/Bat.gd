extends "res://AI/AI_Basic.gd"

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox

var knockback_vector = Vector2.ZERO
var is_dead = false

func _physics_process(delta):
	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, stats.friction * delta)
	knockback_vector = move_and_slide(knockback_vector)
	
	if is_dead:
		if knockback_vector == Vector2.ZERO:
			death()
		return
	
	if state == CHASE:
		sprite.flip_h = (velocity.x + knockback_vector.x) < 0
	
	if state == WANDER:
		sprite.flip_h = (velocity.x) < 0
	
	do_state(delta)

func _on_Hurtbox_area_entered(area):
	# Damage
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	
	# Knockback
	var rel = area.get_owner().position
	var knockback_unit_vector = (Vector2(position[0], position[1]) - Vector2(rel[0], rel[1])).normalized()
	knockback_vector = knockback_unit_vector * stats.knockback

func _on_Stats_no_health():
	is_dead = true

func death():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
