extends PanelContainer

@export var main_scene: PackedScene


func _ready():
  $%StartButton.pressed.connect(on_start_pressed)
  $%QuitButton.pressed.connect(on_quit_pressed)


func on_start_pressed():
  Globals.starting_round_num = int($%RoundNum.value)
  Globals.players = []
  for node in $VBoxContainer/PlayerConfig.get_children():
    var player_name = node.get_node("Name/TextEdit").text
    var ai_player = node.get_node("Type/CheckButton").button_pressed
    Globals.players.append([player_name, ai_player])
  Globals.game = Game.new()
  Globals.game.start_game()
  get_tree().change_scene_to_packed(main_scene)


func on_quit_pressed():
  get_tree().quit()
