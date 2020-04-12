# A script that condenses JSON files and writes everything to a zipped resourcepack. Will also use generated hit
# textures from hit_texture_generator if found
# ONLY WORKS ON WINDOWS until I find a better way to get the .minecraft folder
import json
import os
import zipfile
from pathlib import Path


def minify(file_name):
    file_data = open(file_name, "r", 1).read()  # store file info in variable
    json_data = json.loads(file_data)  # store in json structure
    return json.dumps(json_data, separators=(',', ":"))  # Compact JSON structure


hit_cache = Path(os.environ["APPDATA"], ".minecraft/resourcepacks/mineinabyss-hit-cache/")
mob_model_dir = Path('assets/minecraft/models/item/mob')
textures_dir = Path('assets/minecraft/textures/')

zipf = zipfile.ZipFile(os.path.join(os.environ["APPDATA"], ".minecraft/resourcepacks/Mine in Abyss - Models.zip"), 'w',
                       zipfile.ZIP_DEFLATED)
for root, dirs, files in os.walk("assets/"):
    for file in files:
        if file.endswith(".ini") or file.endswith(".py") or file.endswith(".zip"):
            continue
        if root.__contains__("mob") and root.__contains__("frames"):
            continue
        write_path = os.path.join(root, file)
        if file.endswith(".json"):
            zipf.writestr(write_path, minify(write_path))
            continue
        zipf.write(write_path)

globs = ('**/hit/*', '**/*hit.json')
for glubglob in globs:
    for hit in (hit_cache.glob(glubglob)):
        print(hit)
        zipf.write(hit, hit.relative_to(hit_cache))

zipf.write("pack.mcmeta")
zipf.write("pack.png")
zipf.write("LICENSE")
zipf.close()
