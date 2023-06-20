extends Node2D
class_name Train

@export var train: TrainResource
@export var domino_scene: PackedScene

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var dominos_group: Node = $Dominos
@onready var label: Label = $Label

var x
var y
const rect = Rect2(Vector2(-25, -48), Vector2(Utils.DOMINO_WIDTH / 2, Utils.DOMINO_HEIGHT))


func _ready():
  x = global_position.x
  y = global_position.y
  if train == null:
    return
  if train.dominos == null:
    train.dominos = []
  for d in train.dominos:
    print("Adding " + str(d) + " to the train.")
    _add_domino(d, Vector2(x, y))
    y += Utils.DOMINO_HEIGHT
  _update_label()
  train.domino_added.connect(on_add_domino)


func _draw():
  if train == null || len(train.dominos) == 0:
    draw_rect(rect, Color.GRAY, false, 3)


func _add_domino(d: DominoResource, pos: Vector2):
  var domino_instance = domino_scene.instantiate() as Domino
  domino_instance.domino = DominoResource.new()
  domino_instance.domino.top_num = d.top_num
  domino_instance.domino.bot_num = d.bot_num
  dominos_group.add_child(domino_instance) # doesn't seem to do what I want, which is to keep the area2d drawing above everything else
  domino_instance.set_part_of_train()
  domino_instance.global_position = pos
  if d.flipped:
    domino_instance.rotate(PI)
  _update_label()
  queue_redraw()
  # collision_shape.shape.y += Utils.DOMINO_HEIGHT


func _update_label():
  label.text = str(len(train.dominos))


# func add_domino(d: Domino):
#   _add_domino(d.domino, Vector2(x, y))
#   y += Utils.DOMINO_HEIGHT
#   train.dominos.append(d.domino)
#   _update_label()


func on_add_domino(domino: DominoResource):
  if len(train.dominos) >= 5: # we only want to show 5 dominos at a time
    pass
  _add_domino(domino, Vector2(x, y))
  y += Utils.DOMINO_HEIGHT
  _update_label()