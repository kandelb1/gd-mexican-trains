extends Resource
class_name PlayerResource

@export var name: String
@export var hand: HandResource
@export var train: TrainResource
var color: Color
var is_ai_player: bool


signal hand_changed
signal domino_removed(domino: DominoResource)
signal domino_added(domino: DominoResource)
signal bone_drawn(domino: DominoResource)


func _init(player_name: String, player_train: TrainResource, player_color: Color, is_ai: bool):
  name = player_name
  train = player_train
  color = player_color
  is_ai_player = is_ai
  hand = HandResource.new()  
  train.player_color = player_color


func _to_string():
  print("{0}: I have {1} dominos in my hand.".format([name, hand.get_hand_length()]))


func get_train() -> TrainResource:
  return train


func get_hand() -> HandResource:
  return hand


func add_domino_to_hand(d: DominoResource):
  hand.add_domino(d)
  hand_changed.emit()
  domino_added.emit(d)


func remove_domino_from_hand(d: DominoResource):
  hand.dominos.erase(d)
  domino_removed.emit(d)
  hand_changed.emit()


func draw_bone(d: DominoResource):
  hand.add_domino(d)
  bone_drawn.emit(d)
  hand_changed.emit()


func set_train_status(status: bool):
  train.set_public(status)


func clear():
  hand.clear()
  train.clear()


func has_available_move(playable_trains: Array[TrainResource], round_num: int):
  for t in playable_trains:
    for d in hand.dominos:
      if Globals.game.is_valid_move(d, t):
        return true
  return false


# just make a random move
func make_move(playable_trains: Array[TrainResource]):
  for t in playable_trains:
    for d in hand.dominos:
      if Globals.game.is_valid_move(d, t):
        Globals.game.make_move(d, t)
        return
