extends Resource
class_name TrainResource

@export var dominos: Array[DominoResource] = []
@export var is_supplemental := false
var is_public := false
var player_color: Color

signal domino_added(domino: DominoResource)
signal public_status_changed(is_public: bool)


func get_train_length() -> int:
  return len(dominos)


func get_exposed_num(current_round_num: int) -> int:
  if len(dominos) == 0:
    return current_round_num
  return dominos[-1].get_exposed_num()


func set_public(status: bool):
  is_public = status
  public_status_changed.emit(status)


# returns true if the domino can be added to the end of the train.
# if the train is empty, the domino can only be added if it contains the current round number [0 - 12]
func can_add_domino(domino: DominoResource, current_round_num: int) -> bool:
  # print("Trying to connect domino {0} to {1}".format([domino, get_exposed_num(current_round_num)]))
  return domino.can_connect_to(get_exposed_num(current_round_num))
  # if len(dominos) == 0:
  #   print("trying to connect {0} to {1}".format([domino, current_round_num]))
  #   return domino.can_connect_to(current_round_num)
  # print("Trying to connect {0} to {1}".format([domino, dominos[-1].get_exposed_num()]))
  # return domino.can_connect_to(dominos[-1].get_exposed_num())


# add domino to the end of train, flipping it if necessary
func add_domino(domino: DominoResource, current_round_num: int):
  domino.try_flip_domino(get_exposed_num(current_round_num))
  dominos.append(domino)
  domino_added.emit(domino)


func clear():
  dominos.clear()
  is_public = false