extends HBoxContainer
class_name UIPlayerContainer

@export var player_card_scene: PackedScene

# var players: Array[PlayerResource]

func _ready():
  pass


func set_players(players: Array[PlayerResource]):
  for player in players:
    var player_card = player_card_scene.instantiate() as PlayerCard
    player_card.player = player

    var style = player_card.get_theme_stylebox("panel").duplicate()
    style.border_color = player.color
    player_card.add_theme_stylebox_override("panel", style)
    add_child(player_card)
    
    # player_card.set_player_name(player.name)
    # player_card.set_hand_size(player.hand.get_hand_length())
    # player.domino_removed.connect(update_player_card.bind(player_card))


func set_active_player(player: PlayerResource):
  for child in get_children() as Array[PlayerCard]:
    if child.player == player:
      (child.get_node("AnimationPlayer") as AnimationPlayer).play("flash")
    else:
      (child.get_node("AnimationPlayer") as AnimationPlayer).stop()


func update_player_card(card: PlayerCard):
  pass