extends AnimatedSprite

func _ready():
	frame = 0
	play("Animate")
	connect("animation_finished", self, "animation_finished")

func animation_finished():
	queue_free()
