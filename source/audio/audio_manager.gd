extends Node


signal alien_death()
signal player_shoot()
signal player_vehicle()
signal drill()


signal menu_music()
signal level_music()

signal shop_entered()

signal button_pressed()
signal button_failed()

enum MusicType {
	MENU,
	LEVEL
}

var current_music: MusicType
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")


func _ready() -> void:
	alien_death.connect(_on_alien_death)
	player_shoot.connect(_on_player_shoot)
	player_vehicle.connect(_on_player_vehicle)
	drill.connect(_on_drill)

	level_music.connect(_on_level_music)
	menu_music.connect(_on_menu_music)
	shop_entered.connect(_on_shop_entered)
	
	button_failed.connect(_on_button_failed)
	button_pressed.connect(_on_button_pressed)

	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(0.25))
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(0.25))    

func _on_alien_death() -> void:
	var Scream = $SFX/AlienDeath/Scream
	var Splatter = $SFX/AlienDeath/Splatter
	var Falling = $SFX/AlienDeath/Falling
	Scream.play()
	Splatter.play()
	Falling.play()

func _on_player_shoot() -> void:
	var audioPlayer = $SFX/PlayerShoot
	audioPlayer.play()

func _on_player_vehicle() -> void:
	var audioPlayer = $SFX/PlayerVehicle
	if !audioPlayer.playing:
		audioPlayer.play()

func _on_drill() -> void:
	var audioPlayer = $SFX/Drill
	if !audioPlayer.playing:
		audioPlayer.play()

func switch_music() -> void:
	var menu = $Music/MenuMusic
	var level = $Music/LevelMusic
	
	AudioServer.set_bus_effect_enabled(music_bus_index, 0, false)
	AudioServer.set_bus_effect_enabled(music_bus_index, 1, false)
	if current_music == MusicType.MENU and !menu.playing:
		level.stop()
		menu.play()
	elif current_music == MusicType.LEVEL:
		menu.stop()
		level.play()

func _on_level_music() -> void: 
	current_music = MusicType.LEVEL
	switch_music()

func _on_menu_music() -> void:
	current_music = MusicType.MENU
	switch_music()

func _on_shop_entered() -> void:
	AudioServer.set_bus_effect_enabled(music_bus_index, 1, true)


func _on_button_pressed() -> void:
	var audioPlayer = $SFX/ButtonPressed
	audioPlayer.play()

func _on_button_failed() -> void:
	var audioPlayer = $SFX/ButtonFailed
	audioPlayer.play()
