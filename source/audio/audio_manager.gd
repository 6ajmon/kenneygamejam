extends Node


signal alien_death()
signal player_shoot()
signal player_vehicle()
signal drill()


signal level_music()

func _ready() -> void:
	alien_death.connect(_on_alien_death)
	player_shoot.connect(_on_player_shoot)
	player_vehicle.connect(_on_player_vehicle)
	drill.connect(_on_drill)

	level_music.connect(_on_level_music)

func _on_alien_death() -> void:
	var audioPlayer = $SFX/AlienDeath
	audioPlayer.play()

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

func _on_level_music() -> void:
	var audioPlayer = $Music/LevelMusic
	audioPlayer.play()
