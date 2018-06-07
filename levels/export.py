import sys
import json

data = json.load(open(sys.argv[1]))

palettes = { 37: 1, 44: 1, 62: 2, 63: 2, 64: 2 }
def map_tile(tile):
    tile_id = tile - 1
    return tile_id | palettes.get(tile, 0) << 6

# export tiles
tiles = data["layers"][0]["data"]
binary = bytearray(map(map_tile, tiles))
sys.stdout.buffer.write(binary)

# export objects
keys = ["strawberry", "fly_strawberry", "chest", "key", "jewel",
        "right_cloud", "left_cloud"]
objects = data["layers"][1]["objects"]
start_x = None
start_y = None
output = []
for obj in objects:
    x = int(obj["x"] / 2.0)
    y = int(obj["y"] / 2.0)
    if obj["type"] == "startpos":
        start_x = x
        start_y = y
    else:
        obj_id = keys.index(obj["type"]) + 1
        output += [obj_id, x, y]

output = [start_x, start_y] + output
for i in range(len(output), 16):
    output += [255]
sys.stdout.buffer.write(bytearray(output))

