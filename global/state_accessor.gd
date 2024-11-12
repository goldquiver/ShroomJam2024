extends Node


func set_cutscene_state_all(new_state: bool):
	State.set_all_in_cutscene(new_state)

func set_cutscene_state(char_name: String, new_state: bool):
	State.set_in_cutscene(char_name, new_state)

func get_cutscene_state(char_name: String):
	return State.is_in_cutscene(char_name)

func mute_music():
	var root = State.get_node_in_group("root")
	root.mute_music()

func play_music_spooky():
	var root = State.get_node_in_group("root")
	root.play_music_spooky()

func play_music_spooky_glitch():
	var root = State.get_node_in_group("root")
	root.play_music_spooky_glitch()

func play_music_credits():
	var root = State.get_node_in_group("root")
	root.play_music_credits()
