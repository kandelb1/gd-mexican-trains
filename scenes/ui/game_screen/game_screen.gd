extends Node
class_name GameScreen

@onready var domino: UIDomino = $%Domino


func _ready():
  var game = Globals.game as Game
  domino.update_numbers(game.get_current_round_num(), game.get_current_round_num())