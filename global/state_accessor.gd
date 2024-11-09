extends Node


func set_cutscene_state(new_state: bool):
	State.set_in_cutscene(new_state)

func get_cutscene_state():
	return State.is_in_cutscene()
