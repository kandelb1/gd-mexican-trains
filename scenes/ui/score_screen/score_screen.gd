extends Control

@onready var container = $PanelContainer/MarginContainer/VBoxContainer

signal continue_pressed

var scores = Globals.game.scores

func _ready():
  var player_names = scores[0]
  var header_row = HBoxContainer.new()
  header_row.add_theme_constant_override("separation", 50)
  var dummy_label = Label.new()
  dummy_label.text = ""
  dummy_label.custom_minimum_size = Vector2(200, 0)
  header_row.add_child(dummy_label)
  for name in player_names:
    var label = Label.new()
    label.text = name
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    label.custom_minimum_size = Vector2(50, 0)
    header_row.add_child(label)
  container.add_child(header_row)


  var game_over = false

  for i in range(1, len(scores)):
    var score_row = HBoxContainer.new()
    score_row.add_theme_constant_override("separation", 50)
    var row = scores[i]
    if row[0] == 0:
      game_over = true
    var round_label = Label.new()
    round_label.text = "Round " + str(row[0])
    round_label.custom_minimum_size = Vector2(200, 0)
    score_row.add_child(round_label)
    for j in range(1, len(row)):
      var score_label = Label.new()
      score_label.text = str(row[j])
      score_label.custom_minimum_size = Vector2(50, 0)
      score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
      score_row.add_child(score_label)
    container.add_child(score_row)

  
  var totals_row = HBoxContainer.new()
  totals_row.add_theme_constant_override("separation", 50)
  var totals_label = Label.new()
  totals_label.custom_minimum_size = Vector2(200, 0)
  totals_label.text = "Total Scores:"
  totals_row.add_child(totals_label)
  for total in calc_total_scores():
    var label = Label.new()
    label.custom_minimum_size = Vector2(50, 0)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    label.text = str(total)
    totals_row.add_child(label)
  container.add_child(totals_row)

  if game_over:
    var game_over_label = Label.new()
    game_over_label.text = "Game Over!"
    game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    container.add_child(game_over_label)

    var main_menu_button = Button.new()
    main_menu_button.text = "Main Menu"
    main_menu_button.pressed.connect(on_main_menu_pressed)
    container.add_child(main_menu_button)
    
    var quit_button = Button.new()
    quit_button.text = "Quit"
    quit_button.pressed.connect(on_quit_pressed)
    container.add_child(quit_button)
  else:
    var continue_button = Button.new()
    continue_button.text = "Continue"
    continue_button.pressed.connect(on_continue_pressed)
    container.add_child(continue_button)


func on_continue_pressed():
  continue_pressed.emit()


func on_quit_pressed():
  get_tree().quit()


func on_main_menu_pressed():
  get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
  get_tree().paused = false


func calc_total_scores() -> Array[int]:
  var answer: Array[int] = []
  for i in range(1, len(scores[1])):
    answer.append(0)
  for i in range(1, len(scores)):
    var row = scores[i]
    for j in range(1, len(row)):
      answer[j - 1] += row[j]
  return answer
