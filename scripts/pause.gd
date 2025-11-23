extends Control

@onready var pause_menu = $Pause
@onready var vbox = $Pause/VBoxContainer

@onready var settings = $Settings
@onready var settings_return = $Settings/SettingsReturn
@onready var sound_slider_fill = $Settings/SoundSlider/FillBar
@onready var music_slider_fill = $Settings/MusicSlider/FillBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in vbox.get_children():
		button.mouse_entered.connect(func() -> void:
			button.material.set_shader_parameter("enabled", true)
		)

		button.mouse_exited.connect(func() -> void:
			button.material.set_shader_parameter("enabled", false)
		)

	settings_return.mouse_entered.connect(func() -> void:
		settings_return.material.set_shader_parameter("enabled", true)
	)

	settings_return.mouse_exited.connect(func() -> void:
		settings_return.material.set_shader_parameter("enabled", false)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if settings.visible:
			settings.hide()
			pause_menu.show()
		else:
			pause_menu.visible = true
			settings.visible = false
			self.visible = not (self.visible)
			get_tree().paused = not (get_tree().paused)

func _on_sound_slider_value_changed(value: float) -> void:
	sound_slider_fill.material.set_shader_parameter("progress", value / 100)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), -80.0 if value == 0 else linear_to_db(value / 100.0))

func _on_music_slider_value_changed(value: float) -> void:
	music_slider_fill.material.set_shader_parameter("progress", value / 100)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80.0 if value == 0 else linear_to_db(value / 100.0))


func _on_resume_btn_pressed() -> void:
	print('resume btn')
	self.visible = false
	get_tree().paused = false


func _on_settings_btn_pressed() -> void:
	pause_menu.hide()
	settings.show()


func _on_quit_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_settings_return_pressed() -> void:
	settings.hide()
	pause_menu.show()
