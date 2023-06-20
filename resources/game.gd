extends Resource
class_name Game

signal turn_ended(next_player: PlayerResource)
signal round_ended(scores)

const PLAYER_COLORS = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW]

var dominos: Array[DominoResource]
var trains: Array[TrainResource]
var players: Array[PlayerResource]
var round_num: int
var num_of_players: int
var current_player_index: int
var current_playable_trains: Array[TrainResource] # updated after every move

# ["Bob", "Jeff", "Tim", "Dave"],
# [round num, p1 score, p2 score, p3 score, p4 score]
# [12, 30, 25, 0, 10],
# [11, 15, 50, 5, 9]
var scores = []


func _create_dominos() -> Array[DominoResource]:
  var answer: Array[DominoResource] = []
  for i in range(0, 13):
    for j in range(i, 13):
      if i == j and i == round_num:
        print("SKIPPING DOUBLE ", i)
        continue
      var d = DominoResource.new()
      d.top_num = i
      d.bot_num = j
      answer.append(d)
  answer.shuffle()
  return answer


func _calculate_playable_trains() -> Array[TrainResource]:
  # TODO: if there is an uncovered double, only allow that
  var answer: Array[TrainResource] = []
  for train in trains:
    if train.is_public || train.is_supplemental:
      answer.append(train)
  # also include the current player's train
  answer.append(get_current_player().train) # it doesn't matter if there are duplicates #TODO: does it??
  return answer


func _check_round_over():
  pass


func _next_turn():
  current_player_index += 1
  if current_player_index >= len(players):
    current_player_index = 0
  turn_ended.emit(get_current_player())
  current_playable_trains = _calculate_playable_trains()
  if get_current_player().is_ai_player:
    # await get_tree().create_timer(1).timeout
    if get_current_player().has_available_move(current_playable_trains, round_num):
      print("AI PLAYER MAKING MOVE...")
      get_current_player().make_move(current_playable_trains)
      # _next_turn()
    else:
      print(get_current_player().name, " is drawing, they have ", get_current_player().train.get_train_length(), " dominos on train")
      draw_bone()


func get_current_player() -> PlayerResource:
  return players[current_player_index]


func get_current_round_num() -> int:
  return round_num


func get_players() -> Array[PlayerResource]:
  return players


func is_valid_move(domino: DominoResource, train: TrainResource) -> bool:
  if train in current_playable_trains:
    return train.can_add_domino(domino, round_num)
  return false


func make_move(domino: DominoResource, train: TrainResource):
  train.add_domino(domino, round_num)
  get_current_player().remove_domino_from_hand(domino)
  # if the player is playing on their on own train, set its status to closed
  if train == get_current_player().train:
    print(get_current_player().name, " playing on own train!")
    get_current_player().set_train_status(false)
  if get_current_player().hand.get_hand_length() == 0: # round is over
    var round_scores = [round_num]
    for player in players:
      round_scores.append(player.hand.calculate_score())
    scores.append(round_scores)
    round_ended.emit(scores)
    return
  _next_turn()
  # return 1 if we can move again, 0 if not..?


func draw_bone():
  var player = get_current_player()
  var domino = dominos.pop_back()
  if domino == null: # there are no dominos left, so skip this player's turn
    _next_turn()
    return
  player.draw_bone(domino)
  # only set their train to open if they have at least 1 domino on it
  if get_current_player().train.get_train_length() >= 1:
    get_current_player().set_train_status(true) # true for open, false for closed
  _next_turn()


func start_next_round():
  round_num -= 1
  for player in players:
    player.clear()
  dominos = _create_dominos()

  for i in range(num_of_players):
    var train = trains[i]
    var player = players[i]
    for j in range(15):
      var domino = dominos.pop_back()
      player.add_domino_to_hand(domino)
  
  # don't forget the supplemental train!
  var supplemental = trains[-1]
  supplemental.clear()
  current_player_index = 0
  current_playable_trains = _calculate_playable_trains()


func start_game():
  num_of_players = len(Globals.players)
  round_num = Globals.starting_round_num
  dominos = _create_dominos()
  
  scores = []
  var player_names = []

  players = []
  trains = []
  for i in range(num_of_players):
    var train = TrainResource.new()
    trains.append(train)
    var p_name = Globals.players[i][0]
    var is_ai = Globals.players[i][1]
    var player = PlayerResource.new(p_name, train, PLAYER_COLORS[i], is_ai)
    players.append(player)
    player_names.append(p_name)
    for j in range(15):
      var domino = dominos.pop_back()
      player.add_domino_to_hand(domino)

  scores.append(player_names)
  
  # don't forget the supplemental train!
  var supplemental = TrainResource.new()
  supplemental.is_supplemental = true
  supplemental.is_public = true
  trains.append(supplemental)
  current_player_index = 0
  current_playable_trains = _calculate_playable_trains()
  print("Game: game started")
