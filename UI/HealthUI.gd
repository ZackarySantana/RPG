extends Control

var max_hearts = 4
var hearts = max_hearts setget set_hearts

onready var empty = $EmptyHearts
onready var full = $FullHearts

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	full.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(max_hearts, 1)
	empty.rect_size.x = hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("changed_health", self, "set_hearts")
	PlayerStats.connect("changed_max_health", self, "set_max_hearts")
