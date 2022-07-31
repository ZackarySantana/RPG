extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/StartingArea.tscn")

func _on_Controls_pressed():
	get_tree().change_scene("res://Menus/Controls.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://Menus/Options.tscn")

func _on_Quit_pressed():
	get_tree().quit()

