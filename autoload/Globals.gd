extends Node

func _ready():
  print("GLOBALS.GD LOADED")

var starting_round_num: int
# [name, ai_player?]
# ["Bob", false], ["Jim", true]
var players = []
var scores = []
var game: Game