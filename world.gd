extends StaticBody2D

#func _process(_delta: float) -> void:
	#var viewport_rect = get_viewport_rect()
	#$Polygon2D.polygon[0] = viewport_rect.position + Vector2.DOWN * viewport_rect.size.y * 0.5
	#$Polygon2D.polygon[1] = viewport_rect.position + Vector2.RIGHT * viewport_rect.size.x * 0.5
	#$Polygon2D.polygon[3] = viewport_rect.position 
	#$Polygon2D.polygon[2] = viewport_rect.position + viewport_rect.size * 0.5
	##$Polygon2D.polygon[0] = viewport_rect.position
	##$Polygon2D.polygon[1] = viewport_rect.position + viewport_rect.size.x * Vector2.RIGHT
	##$Polygon2D.polygon[2]
	##$Polygon2D.polygon[3]
