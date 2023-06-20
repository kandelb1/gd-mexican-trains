extends Resource
class_name DominoResource

@export_range(0, 12) var top_num := 5
@export_range(0, 12) var bot_num := 6

var flipped := false

#signal values_changed

# func _init(top_num: int, bot_num: int):
#   self.top_num = top_num
#   self.bot_num = bot_num

func get_exposed_num():
  if flipped:
    return top_num
  return bot_num


func is_double():
  return top_num == bot_num


# flips this domino (if it should)
func try_flip_domino(num: int):
  if bot_num == num:
    flipped = true


# returns true if this domino has other_num on the top or bottom
func can_connect_to(other_num: int) -> bool:
  return top_num == other_num || bot_num == other_num


func get_score_value() -> int:
  return top_num + bot_num


func _to_string():
  return "({0}/{1} flipped={2})".format([top_num, bot_num, flipped])