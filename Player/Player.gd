extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

onready var hurtbox = $Hurtbox

enum {
	MOVE, ROLL, SWORD_ATTACK, SWORD_ATTACK_ALL
}

var state = MOVE
var cooldown = 0

func _ready():
	randomize()
	PlayerStats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
			attempt_action(delta)
		SWORD_ATTACK:
			attack(delta)
			sword_attack(delta)
		SWORD_ATTACK_ALL:
			attack(delta)
			sword_attack_all(delta)
		ROLL:
			roll(delta)
			
func attempt_action(delta):
	if cooldown <= 0:
		if Input.is_action_just_pressed("sword_attack"):
			state = SWORD_ATTACK
			cooldown = PlayerStats.SWORD_ATTACK_COOLDOWN
		
		if Input.is_action_just_pressed("sword_attack_all"):
			state = SWORD_ATTACK_ALL
			cooldown = PlayerStats.SWORD_ATTACK_ALL_COOLDOWN
			
		if Input.is_action_just_pressed("roll"):
			state = ROLL
			cooldown = PlayerStats.ROLL_COOLDOWN
	else:
		cooldown -= delta

# ========== Attack Code ==========

func attack(delta):
	velocity = Vector2.ZERO

func sword_attack(delta):
	animation_state.travel("SwordAttack")
	
func sword_attack_all(delta):
	animation_state.travel("SwordAttackAll")

# Used in the Animation's endings
func AttackFinished(name):
	state = MOVE

# ========== Roll Code ==========

func roll(delta):
	velocity = facing_vector * PlayerStats.max_speed * 1.55
	animation_state.travel("Roll")
	move_with_velocity()

# Used in the Animation endings
func RollFinished():
	velocity = velocity.normalized() * PlayerStats.max_speed
	state = MOVE

# ========== Movement Code ==========

var velocity = Vector2.ZERO
var facing_vector = Vector2.DOWN

func move(delta):
	var inputv = Vector2.ZERO
	
	inputv.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputv.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputv = inputv.normalized()
	
	if inputv != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", inputv)
		
		animation_tree.set("parameters/Run/blend_position", inputv)
		animation_tree.set("parameters/Roll/blend_position", inputv)
		
		animation_tree.set("parameters/SwordAttack/blend_position", inputv)
		animation_tree.set("parameters/SwordAttackAll/blend_position", inputv)
		
		animation_state.travel("Run")
		facing_vector = inputv
		velocity = velocity.move_toward(inputv * PlayerStats.max_speed, PlayerStats.acceleration * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, PlayerStats.friction * delta)
		
	move_with_velocity()

func move_with_velocity():
	velocity = move_and_slide(velocity)
	
# ========== Hurtbox ===========

func _on_Hurtbox_area_entered(area):
	PlayerStats.health -= 1
	hurtbox.start_invincible(0.5)
	hurtbox.create_hit_effect()
