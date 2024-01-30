##Questa è la documentazione del Bioma
class_name  Bioma
extends Resource

##Nome del bioma - comparirà nell'inpector
@export var bioma_name: String = 'unknown_bioma'
##Profondità massima di presenza di questo bioma
@export var range_start: int = 0
##Profondità minima di presenza di questo bioma
@export var range_end: int = 0

##Indice del TileSet della TileMap
@export var terrain_set: int = 0
##indice specifico sul TerrainSet
@export var terrain: int = 0
##Indica il valore minimo che la NoiseMap deve avere in quel punto specifico per poter mostrare questo bioma
@export var tile_map_offset: float = 0

##Specifica se su questo bioma è possibile impilare altri biomi, indica se è portante
@export var bearer: bool = true
@export var plane: int = 0

