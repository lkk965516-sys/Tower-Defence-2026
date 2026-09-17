
extends Node

var audio_pool = []
var music_player: AudioStreamPlayer 


var sfx = {
	"button_press": preload("res://SFX/button-394464.mp3"),
	"game_over": preload("res://SFX/game-over-38511.mp3"),
	"game_start": preload("res://SFX/game-start-6104.mp3"),
	"enemy_hurt": preload("res://SFX/hurt_c_08-102842.mp3"),
	"enemy_die": preload("res://SFX/universfield-game-character-140506.mp3"),
	"currency_gain": preload("res://SFX/material-gold-394476.mp3"),
	"currency_loss": preload("res://SFX/material-buy-success-394517.mp3"),
	"game_win": preload("res://SFX/level-complete-394515.mp3"),
	"wave_start" : preload("res://SFX/tuomas_data-game-countdown-62-199828.mp3"),
	"wave_end" : preload("res://SFX/freesound_community-080205_life-lost-game-over-89697.mp3"),
	"lose_life": preload("res://SFX/freesound_community-080205_life-lost-game-over-89697.mp3"),
	"shoot": preload("res://SFX/freesound_community-shoot02wav-14562.mp3"),
	"impact": preload("res://SFX/ribhavagrawal-hit-soundvideo-game-type-230510.mp3"),
}

var music = {
	"song_1": preload("res://SFX/xtremefreddy-game-music-loop-16-153389.mp3"),
	"song_2": preload("res://SFX/xtremefreddy-game-music-loop-18-153392.mp3")
}

func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			if child.name == "MusicPlayer":
				music_player = child
			else :
				audio_pool.append(child)
	
	
func play_sfx(sfx_) -> void:
	var sound = sfx[sfx_]
	for player: AudioStreamPlayer in audio_pool:
		if not player.playing:
			player.stream = sound
			player.play()
			return

func play_music(music_) -> void:
	if music_player.playing:
		music_player.stop()
	music_player.stream = music[music_]
	music_player.play()


func stop_music() -> void:
	if music_player.playing:
		music_player.stop()
