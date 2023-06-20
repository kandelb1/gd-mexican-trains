extends Node
class_name GameManager

signal spawn_train(train: TrainResource)
signal spawn_player(player: PlayerResource)
signal turn_ended(next_player: PlayerResource)
signal bone_drawn(count: int)
signal round_ended(scores)

var game: Game
var players: Array[Player]
var trains: Array[UITrain]


func _ready():
  game = Game.new()
  game.spawn_train.connect(func(train: TrainResource): spawn_train.emit(train))
  game.spawn_player.connect(func(player: PlayerResource): spawn_player.emit(player))
  game.turn_ended.connect(on_turn_end)
  game.round_ended.connect(on_round_end)
  players = []
  trains = []


func start_game():
  game.start_game()
  # I have to do it this way to avoid stupid type errors
  players.append_array(get_tree().get_nodes_in_group("players") as Array[Player])
  trains.append_array(get_tree().get_nodes_in_group("trains") as Array[UITrain])
  # show the first player's hand
  players[0].show_hand()


func on_turn_end(next_player: PlayerResource):
  for player in players:
    if player.player == next_player:
      player.show_hand()
    else:
      player.hide_hand()
  turn_ended.emit(next_player)


func on_round_end(scores):
  round_ended.emit(scores)


func try_place_domino(domino: DominoResource, train: TrainResource):
  if game.is_valid_move(domino, train):
    # if the player is playing on their on own train, set its status to closed
    if train == game.get_current_player().train:
      print("PLAYING ON OWN TRAIN!")
      game.get_current_player().set_train_status(false)
    game.make_move(domino, train)


# set the player's train to open and give them a bone
func bonepile_clicked():
  # only set their train to open if they have at least 1 domino on it
  if game.get_current_player().train.get_train_length() >= 1:
    game.get_current_player().set_train_status(true) # true for open, false for closed
  game.draw_bone()  
  bone_drawn.emit(len(game.dominos)) # to update the UI


func start_next_round():
  for player in players:
    player.clear_hand()
  for train in trains:
    train.clear()
  game.start_next_round()
  # show the first player's hand
  for player in players:
    player.hide_hand()
  players[0].show_hand()


func get_current_player() -> PlayerResource:
  return game.get_current_player()
