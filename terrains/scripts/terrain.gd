extends TileMap
class_name Terrain

enum _IDS {
	FLOOR = 0,
	SMALL_DECORATION = 1
}

enum _LAYERS {
	BASE_TERRAIN = 0,
	PATH_TERRAIN = 1,
	SMALL_DECORATION_TERRAIN = 2
}

@export_category("Variables")
@export var _small_decoration_tile_prob: float = 0.05 #5%

func _ready() -> void:
	for _cell in get_used_cells(_LAYERS.BASE_TERRAIN):
		match get_cell_atlas_coords(_LAYERS.BASE_TERRAIN, _cell):
			Vector2i(0, 12):
				var _random_number: float = randf()
				if _random_number > _small_decoration_tile_prob:
					continue
					
				var _random_x_1: int = randi() % 9
				var _random_x_2: int = randi() % 8
				
				var _random_cell_1: Vector2i = Vector2i(_random_x_1, 0)
				var _random_cell_2: Vector2i = Vector2i(_random_x_2, 2)
				var _cells_list: Array = [_random_cell_1, _random_cell_2]
				
				set_cell(
					_LAYERS.SMALL_DECORATION_TERRAIN,
					_cell,
					_IDS.SMALL_DECORATION,
					_cells_list[randi() % _cells_list.size()]
				)
