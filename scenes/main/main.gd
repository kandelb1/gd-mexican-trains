extends Node

@export var train_scene: PackedScene
@export var player_scene: PackedScene
@export var score_screen_scene: PackedScene
@export var main_scene: PackedScene

@onready var mouse_manager: MouseManager = $Managers/MouseManager
@onready var trains_node = $Trains
@onready var players_node = $Players
@onready var ui_node = $UI
@onready var bonepile: Bonepile = $UI/Bonepile
@onready var round_num_domino: UIDomino = $%RoundNumDomino

const supplemental_spawn_pos = Vector2(1000, 250)
var train_spawn_pos = Vector2(110, 250)

signal bone_drawn(count: int)


func _ready():
  var game = Globals.game
  if game == null:
    print("ERROR")
    get_tree().quit(1)

  # update UI
  round_num_domino.update_numbers(game.get_current_round_num(), game.get_current_round_num())

  var player_container = $UI/PlayerContainer as UIPlayerContainer
  player_container.set_players(game.players)
  player_container.set_active_player(game.players[0])

  bone_drawn.connect(bonepile.update_bones_left)
  bonepile.update_bones_left(len(game.dominos))

  # spawn players and their trains
  print("Main: spawning players and trains")
  for player in game.get_players():
    spawn_a_train(player.get_train())
    spawn_a_player(player)
  
  # don't forget the supplemental!
  spawn_a_train(game.trains[-1])
  
  # show first player's hand
  players_node.get_children()[0].show_hand()

  mouse_manager.try_place_domino.connect(try_place_domino)
  mouse_manager.bonepile_clicked.connect(bonepile_clicked)

  game.turn_ended.connect(on_turn_end)
  game.round_ended.connect(on_round_end)


func on_turn_end(next_player: PlayerResource):
  $AudioStreamPlayer2D.play()
  for player in players_node.get_children():
    if player.player == next_player:
      if !player.player.is_ai_player:
        player.show_hand()
      # else:
      #   print("NOT SHOWING AI PLAYERS HAND")
    else:
      player.hide_hand()
  var player_container = $UI/PlayerContainer as UIPlayerContainer
  player_container.set_active_player(next_player)


func try_place_domino(domino: DominoResource, train: TrainResource):
  print("trying to place domino ", domino, " on train " , train)
  print("is supplemental? : ", train.is_supplemental)
  if Globals.game.is_valid_move(domino, train):
    Globals.game.make_move(domino, train)


# set the player's train to open and give them a bone
 # TODO: prevent players from drawing if they have an available move
func bonepile_clicked():
  Globals.game.draw_bone()
  bone_drawn.emit(len(Globals.game.dominos)) # to update the UI


func spawn_a_train(train: TrainResource):
  var train_instance = train_scene.instantiate() as UITrain
  train_instance.train = train
  if train.is_supplemental:
    train_instance.global_position = supplemental_spawn_pos
  else:
    train_instance.global_position = train_spawn_pos
    train_spawn_pos.x += 150
  trains_node.add_child(train_instance)


func spawn_a_player(player: PlayerResource):
  var player_instance = player_scene.instantiate() as Player
  player_instance.player = player
  players_node.add_child(player_instance)
  player_instance.hide_hand()


func on_round_end(scores):
  var score_screen = score_screen_scene.instantiate()
  score_screen.scores = scores
  score_screen.continue_pressed.connect(on_continue_pressed)
  ui_node.add_child(score_screen)
  get_tree().paused = true


func on_continue_pressed():
  Globals.game.start_next_round()
  get_tree().paused = false
  get_tree().reload_current_scene()


func get_trains() -> Array[UITrain]:
  return trains_node.get_children() as Array[UITrain]


func get_players() -> Array[Player]:
  return players_node.get_children() as Array[Player]


func get_player_resources() -> Array[PlayerResource]:
  var players: Array[PlayerResource] = []
  for node in players_node.get_children() as Array[Player]:
    players.append(node.player)
  return players
