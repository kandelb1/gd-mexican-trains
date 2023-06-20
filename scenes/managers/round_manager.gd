extends Node
class_name RoundManager


var round_num: int


func _ready():
  round_num = 12


func next_round():
  round_num -= 1