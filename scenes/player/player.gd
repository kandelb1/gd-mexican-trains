extends Node
class_name Player


@export var domino_scene: PackedScene
var player: PlayerResource

func _ready():
  player.domino_added.connect(on_domino_added)
  for d in player.hand.dominos:
    var domino_instance = domino_scene.instantiate() as Domino
    domino_instance.domino = d
    var pos = Vector2(randi_range(200, 1000), randi_range(450, 650))
    domino_instance.global_position = pos
    add_child(domino_instance)
  player.domino_removed.connect(on_domino_removed)
  player.bone_drawn.connect(on_bone_drawn)


func hide_hand():
  for child in get_children() as Array[Domino]:
    child.hide_domino()


func show_hand():
  for child in get_children() as Array[Domino]:
    child.show_domino()


func on_domino_removed(domino: DominoResource):
  for child in get_children() as Array[Domino]:
    if child.domino == domino:
      child.queue_free()
      break

func on_domino_added(d: DominoResource):
  var domino_instance = domino_scene.instantiate() as Domino
  domino_instance.domino = d
  var pos = Vector2(randi_range(200, 1000), randi_range(450, 650))
  domino_instance.global_position = pos
  add_child(domino_instance)


func on_bone_drawn(domino: DominoResource):
  var domino_instance = domino_scene.instantiate() as Domino
  domino_instance.domino = domino
  var pos = Vector2(200, 650) # TODO: make some kind of drawing animation? can we tween the domino from the bonepile to our hand?
  domino_instance.global_position = pos
  add_child(domino_instance)


func clear_hand():
  for child in get_children():
    child.queue_free()