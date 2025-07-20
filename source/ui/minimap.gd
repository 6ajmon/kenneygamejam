extends Control

@export var minimap_size: float = 200.0
@export var world_size: float = 60.0
@export var update_interval: float = 0.1
@export var player_color: Color = Color.CYAN
@export var enemy_color: Color = Color.RED
@export var enemy_close_color: Color = Color.ORANGE_RED
@export var background_color: Color = Color(0.1, 0.1, 0.1, 0.9)
@export var border_color: Color = Color.WHITE
@export var grid_color: Color = Color(0.3, 0.3, 0.3, 0.6)
@export var close_distance_threshold: float = 15.0
@export var enemy_sprite: Texture2D
@export var player_sprite: Texture2D

var update_timer: float = 0.0
var player_position: Vector3
var enemy_positions: Array[Vector3] = []

func _ready() -> void:
	custom_minimum_size = Vector2(minimap_size, minimap_size)
	
func _process(delta: float) -> void:
	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		update_positions()
		queue_redraw()

func update_positions() -> void:
	player_position = GameData.PlayerPosition
	
	enemy_positions.clear()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.has_method("get_global_position"):
			enemy_positions.append(enemy.global_position)

func _draw() -> void:
	var rect = get_rect()
	var center = rect.size / 2
	var radar_radius = min(rect.size.x, rect.size.y) / 2 - 10
	
	draw_circle(center, radar_radius, background_color)
	
	var grid_radius = radar_radius / 2
	draw_arc(center, grid_radius, 0, TAU, 32, grid_color, 1.0)
	draw_line(Vector2(center.x - radar_radius, center.y), Vector2(center.x + radar_radius, center.y), grid_color, 1.0)
	draw_line(Vector2(center.x, center.y - radar_radius), Vector2(center.x, center.y + radar_radius), grid_color, 1.0)
	
	draw_arc(center, radar_radius, 0, TAU, 32, border_color, 2.0)
	
	if player_position == Vector3.ZERO:
		return
	
	for enemy_pos in enemy_positions:
		var relative_pos = enemy_pos - player_position
		var distance_to_enemy = relative_pos.length()
		
		var minimap_pos = Vector2(-relative_pos.z, relative_pos.x) * (radar_radius / world_size) + center
		
		if center.distance_to(minimap_pos) <= radar_radius:
			var color = enemy_close_color if distance_to_enemy <= close_distance_threshold else enemy_color
			var enemy_size = 32
			
			if enemy_sprite:
				var sprite_size = Vector2(enemy_size, enemy_size)
				var sprite_pos = minimap_pos - sprite_size / 2
				draw_texture_rect(enemy_sprite, Rect2(sprite_pos, sprite_size), false, color)
			else:
				draw_circle(minimap_pos, enemy_size / 2.0, color)
	
	if player_sprite:
		var player_size = Vector2(32, 32)
		
		var player_rotation = -GameData.PlayerRotation + PI/2
		var transform = Transform2D(player_rotation, center)
		draw_set_transform_matrix(transform)
		draw_texture_rect(player_sprite, Rect2(-player_size/2, player_size), false, player_color)
		draw_set_transform_matrix(Transform2D())
	else:
		draw_circle(center, 16, player_color)
		draw_circle(center, 12, Color.WHITE)
		
		var player_rotation = -GameData.PlayerRotation + PI/2
		var forward_direction = Vector2(sin(player_rotation), -cos(player_rotation)) * 20
		draw_line(center, center + forward_direction, player_color, 4.0)
	
