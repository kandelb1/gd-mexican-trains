extends Node2D
class_name Domino

@export var domino: DominoResource

@onready var top_image = $BaseImage/TopImage
@onready var bot_image = $BaseImage/BottomImage
@onready var collision_shape = $Area2D/CollisionShape2D

var is_part_of_train = false


func _ready():
  set_textures()


func set_textures():
  top_image.texture = Utils.get_texture_from_num(domino.top_num)
  bot_image.texture = Utils.get_texture_from_num(domino.bot_num)


func set_part_of_train():
  is_part_of_train = true


func hide_domino():
  hide()
  collision_shape.disabled = true


func show_domino():
  show()
  collision_shape.disabled = false
