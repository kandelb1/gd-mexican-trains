extends Resource
class_name HandResource

@export var dominos: Array[DominoResource] = []

# maybe we need stuff like this? it makes sense for this code to live here, and for a separate Hand scene to actually render the hand
signal domino_played
signal double_played

func get_hand_length() -> int:
  return len(dominos)


func add_domino(d: DominoResource):
  dominos.append(d)


func calculate_score() -> int:
  var score = 0
  for domino in dominos:
    score += domino.get_score_value()
  return score


func clear():
  dominos.clear()