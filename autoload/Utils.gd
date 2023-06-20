extends Node

const DOMINO_HEIGHT = 96
const DOMINO_WIDTH = 52
var domino_textures: Array[Resource]

func _ready():
  create_domino_textures()
  print("Utils.gd: Domino textures created.")


func get_texture_from_num(num: int) -> Resource:
  if num == 0:
    return null
  return domino_textures[num - 1]


func create_domino_textures():
  domino_textures = []
  for num in range(1, 13):
    var texture = load("res://assets/" + num_to_image_name(num) + ".png")
    domino_textures.append(texture)


func num_to_image_name(num):
  match(num):
    1:
      return "One"
    2:
      return "Two"
    3:
      return "Three"
    4:
      return "Four"
    5:
      return "Five"
    6:
      return "Six"
    7:
      return "Seven"
    8:
      return "Eight"
    9:
      return "Nine"
    10:
      return "Ten"
    11:
      return "Eleven"
    12:
      return "Twelve"