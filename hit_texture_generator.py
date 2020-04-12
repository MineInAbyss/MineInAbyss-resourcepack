# generates red versions of textures to act as hit models. Will generate a cache in the .minecraft folder
# ONLY WORKS ON WINDOWS until I find a better way to get the .minecraft folder
import json
import os
from pathlib import Path
from shutil import copyfile

from PIL import Image

hit_cache = Path(os.environ["APPDATA"]) / '.minecraft/resourcepacks/mineinabyss-hit-cache/'

RERENDER = False
mob_model_dir = Path('./assets/minecraft/models/item/mob')
textures_dir = Path('./assets/minecraft/textures/')
used_textures = []

# duplicate all the models with the texture path changed
for mob in (mob_model_dir.glob('*')):
    for model_path in (mob.glob('*')):
        model_name: str = model_path.name[:-5]
        parents = model_path.parents
        # model_dir = model_path.parent
        # make sure file is a json file and not a _hit one, and without digits in its name (usually frames)
        if model_path.suffix == ".json" \
                and not model_name.__contains__('_hit') \
                and not model_name.__contains__('walking') \
                and not any(char.isdigit() for char in model_path.name):
            hit_json = hit_cache / mob / (model_name + '_hit.json')
            if os.path.isfile(hit_json) and not RERENDER:
                print("Skipping model for " + model_name + ", hit version already exists")
                continue

            print("Generating JSON for: " + str(model_path))
            # Read file and make add "_hit" to all textures
            data = json.load(model_path.open('r'))

            original_texture_path = ''

            # try:
            if "textures" in data:
                for texture in (data["textures"]):
                    json_texture_path = Path(data["textures"][texture])
                    original_texture_path = textures_dir / (str(json_texture_path) + '.png')
                    # if texture doesn't already end with a "_hit"
                    if not json_texture_path.name.endswith("_hit"):
                        json_hit_texture_path = json_texture_path.parent / 'hit' / json_texture_path.name
                        data["textures"][texture] = str(json_hit_texture_path).replace('\\', '/')

                        # generate red hit texture if texture hasn't already been used
                        if [original_texture_path] not in used_textures:
                            used_textures.append([original_texture_path])

                            print('Generating hit texture for: ' + str(original_texture_path))
                            try:
                                original_image = Image.open(str(original_texture_path)).convert("RGBA")
                            except FileNotFoundError:
                                continue

                            # create the coloured overlays
                            red = Image.new('RGBA', original_image.size, (255, 0, 0, 255))

                            # create a mask using RGBA to define an alpha channel to make the overlay transparent
                            mask = Image.new('RGBA', original_image.size, (255, 255, 255, 200))

                            # create a composite of the images
                            new_image = Image.composite(original_image, red, mask).convert("RGBA")

                            # make originally transparent pixels transparent again
                            pix_data = original_image.load()
                            new_pix_data = new_image.load()
                            width, height = original_image.size
                            for y in range(height):
                                for x in range(width):
                                    # if opacity is 0
                                    if pix_data[x, y][3] == 0:
                                        # set opacity in the same pixel on new image to 0
                                        new_pix_data[x, y] = (0, 0, 0, 0)

                            # save image
                            save_file = hit_cache / textures_dir / (str(json_hit_texture_path) + '.png')
                            # if not save_dir.exists():
                            #     os.makedirs(save_dir)
                            print(save_file)
                            os.makedirs(save_file.parent, exist_ok=True)
                            new_image.save(save_file)
            # prevent errors with models without texture paths or non existing texture paths
            else:
                print("Skipping: " + str(model_path) + " (no textures found)")
                continue

            # write hit json file
            os.makedirs(hit_json.parent, exist_ok=True)
            json.dump(data, hit_json.open('w'))

            # check for an mcmeta file, copy and rename appropriately if found
            texture_dir = Path(original_texture_path.parent)

            # check for an mcmeta file, copy and rename appropriately if found
            for mcmeta in (texture_dir.glob('*.mcmeta')):
                # don't copy already generated _hit mcmeta files
                if not mcmeta.name.__contains__('_hit'):
                    copyfile(str(mcmeta), str(hit_cache / texture_dir / 'hit' / mcmeta.name))
                    print('Copying MCMETA file to: ' + str(texture_dir / 'hit' / mcmeta.name))
            print('\n\n')
