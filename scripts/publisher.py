# A script that condenses JSON files and writes everything to a zipped resourcepack. Will also use generated hit
# textures from hit_texture_generator if found
# ONLY WORKS ON WINDOWS until I find a better way to get the .minecraft folder
import json
import os
import zipfile
from json.decoder import JSONDecodeError
from pathlib import Path

# set working dir to this file
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

from hit_texture_generator import hit_gen_dir, root_dir, output_dir


def minify(file_name: str):
    file_data = open(file_name, "r", 1, encoding = "utf8").read()  # store file info in variable
    json_data = json.loads(file_data)  # store in json structure
    return json.dumps(json_data, separators=(',', ":"))  # Compact JSON structure


version_file = root_dir / 'version/version.txt'
if os.path.isfile(version_file):
    version = open(version_file, "rt").read()
else:
    version = "DEV"
print("Got version: " + version)

print("Building font files")
for file in os.scandir(root_dir / "assets/minecraft/font/"):
    if file.is_dir():
        data = {"providers":[]}
        # Scan all the subfiles in this directory
        for root, dirs, files in os.walk(file):
            for subfile in files:
                if subfile.endswith(".json"):
                    file_data = open(os.path.join(root,subfile), "r", 1, encoding = "utf8").read()
                    json_data = json.loads(file_data)
                    provider_list = json_data["providers"]
                    data["providers"] = data["providers"] + provider_list
                    print(f"Added {root}/{subfile} to {file.name}")

        # Save the combined data in a new file
        if len(data["providers"]):
            minified = json.dumps(data, separators=(',', ":"))
            name = file.name + ".json"
            write_path = Path(root_dir / "assets/minecraft/font" / name ).absolute().resolve()
            print(f"Saving font {file.name} to {write_path.as_uri()}")
            with open( write_path, "w", encoding = "utf8" ) as font_file:
                print(minified, file = font_file)
        else:
            print(f"Nothing detected for font {file.name}" )

print("Create zip file and add minified json into it")
zipf = zipfile.ZipFile(output_dir / "MineInAbyss-Models.zip", 'w', zipfile.ZIP_DEFLATED)
for root, dirs, files in os.walk(root_dir / "assets/"):
    for file in files:
        if file.endswith(".ini") or file.endswith(".py") or file.endswith(".zip"):
            continue
        if root.__contains__("excluded") or (root.__contains__("mob") and root.__contains__("frames")):
            continue
        read_path = Path(root) / file
        write_path = read_path.relative_to(root_dir)
        if file.endswith(".json"):
            try:
                minified = minify(read_path)
                zipf.writestr(str(write_path), str(minified))
                continue
            except (UnicodeDecodeError, JSONDecodeError):
                print(f'Could not minify {write_path}, using original instead. Is it valid JSON?')
        zipf.write(read_path, write_path)

print("Add hit models & textures to the zip")
for root, dirs, files in os.walk(hit_gen_dir):
    for file in files:
        read_path = Path(root) / file
        write_path = read_path.relative_to(hit_gen_dir)
        zipf.write(read_path, write_path)

print("Edit pack.mcmeta to be the correct version from github actions")
mcmeta = open(root_dir / 'pack.mcmeta', "rt")
data = mcmeta.read()
data = data.replace('vDEV', 'v' + version)
zipf.writestr("pack.mcmeta", data)
mcmeta.close()

print("Add some extra files")
zipf.write(root_dir / "pack.png", "pack.png")
zipf.write(root_dir / "LICENSE", "LICENSE")
zipf.close()
