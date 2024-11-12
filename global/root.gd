extends Node

@onready var rootMapNode = $CurrentScene
@onready var saved_scenes = $SavedScenes

@onready var audio_sources = $AudioSources
@onready var mus_spooky = $AudioSources/mus_spooky
@onready var mus_spooky_glitch = $AudioSources/mus_spooky_glitch
@onready var mus_credit = $AudioSources/mus_credit


var trigger_data = {}


func track_audio_source(target: Node2D):
	audio_sources.position = target.position


func mute_music():
	mus_spooky.volume_db = -80
	mus_spooky_glitch.volume_db = -80
	mus_credit.volume_db = -80


func play_music_spooky():
	if not mus_spooky.playing:
		mus_spooky.play()
		mus_spooky_glitch.play()
	mus_spooky.volume_db = 0
	mus_spooky_glitch.volume_db = -80


func play_music_spooky_glitch():
	if not mus_spooky_glitch.playing:
		mus_spooky.play()
		mus_spooky_glitch.play()
	mus_spooky.volume_db = -80
	mus_spooky_glitch.volume_db = 0


func play_music_credits():
	mus_spooky.volume_db = -80
	mus_spooky_glitch.volume_db = -80
	mus_credit.play()
	mus_credit.volume_db = 0


func has_trigger_data(trigger_name: String) -> bool:
	return trigger_data.has(trigger_name)


func get_trigger_data(trigger_name: String):
	if trigger_data.has(trigger_name):
		return trigger_data[trigger_name]
	return null


func set_trigger_data(trigger_name: String, new_data):
	trigger_data[trigger_name] = new_data


func change_map(map_path: String):
	# Grab new and old root nodes
	var old_map = rootMapNode.get_child(0)
	var new_map
	
	# Search for map existing in scene tree
	var filename = map_path.get_file()
	filename = filename.substr(0, filename.length() - 5)
	
	new_map = saved_scenes.get_node_or_null(filename)
	
	if new_map:
		new_map.visible = true
		new_map.reparent(rootMapNode)
		new_map.set_process_mode(PROCESS_MODE_INHERIT)
	else:
		new_map = load(map_path) as PackedScene
		var new_scene = new_map.instantiate()
		rootMapNode.add_child(new_scene)

	# Remove old map
	old_map.visible = false
	old_map.reparent(saved_scenes)
	old_map.set_process_mode(PROCESS_MODE_DISABLED)
	
	# check for the glorbo cutscene to play on reload map
	if new_map.has_method("check_glorbo_cutscene"):
		new_map.check_glorbo_cutscene()


# Signals


func _on_mus_spooky_finished():
	mus_spooky.play()


func _on_mus_spooky_glitch_finished():
	mus_spooky_glitch.play()


func _on_mus_credit_finished():
	mus_credit.play()
