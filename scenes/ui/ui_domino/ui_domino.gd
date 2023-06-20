extends Control
class_name UIDomino


@export var domino: DominoResource

@onready var base_image: TextureRect = $BaseImage
@onready var top_image: TextureRect = $BaseImage/TopImage
@onready var bot_image: TextureRect = $BaseImage/BotImage

var is_part_of_train = false


func _ready():
  set_textures()


func update_numbers(top_num: int, bot_num: int):
  domino.top_num = top_num
  domino.bot_num = bot_num
  set_textures()


func set_textures():
  top_image.texture = Utils.get_texture_from_num(domino.top_num)
  bot_image.texture = Utils.get_texture_from_num(domino.bot_num)


func flip_upside_down():
  base_image.rotation = PI


func flip_sideways():
  custom_minimum_size = Vector2(96, 53) # easy
  base_image.rotation = PI / 2