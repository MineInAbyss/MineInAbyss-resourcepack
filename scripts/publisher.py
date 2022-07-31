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

#from hit_texture_generator import hit_gen_dir, root_dir, output_dir
root_dir = Path('../')
output_dir = root_dir / 'out/'
hit_gen_dir = output_dir / 'hit_gen'
mob_models = 'survival/assets/minecraft/models/creatures'
textures = 'survival/assets/minecraft/textures/'

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

print("Create zip file for survival and add minified json into it")
zipS = zipfile.ZipFile(output_dir / "MineInAbyss-Survival-Resourcepack.zip", 'w', zipfile.ZIP_DEFLATED)
for root, dirs, files in os.walk(root_dir / "survival/assets/"):
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
                zipS.writestr(str(write_path), str(minified))
                continue
            except (UnicodeDecodeError, JSONDecodeError):
                print(f'Could not minify {write_path}, using original instead. Is it valid JSON?')
        zipS.write(read_path, write_path)

print("Add hit models & textures to the zip")
for root, dirs, files in os.walk(hit_gen_dir):
    for file in files:
        read_path = Path(root) / file
        write_path = read_path.relative_to(hit_gen_dir)
        zipS.write(read_path, write_path)

print("Create zip file for build and add minified json into it")
zipB = zipfile.ZipFile(output_dir / "MineInAbyss-Build-Resourcepack.zip", 'w', zipfile.ZIP_DEFLATED)
for root, dirs, files in os.walk(root_dir / "build/assets/"):
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
                zipB.writestr(str(write_path), str(minified))
                continue
            except (UnicodeDecodeError, JSONDecodeError):
                print(f'Could not minify {write_path}, using original instead. Is it valid JSON?')
        zipB.write(read_path, write_path)


print("Edit pack.mcmeta to be the correct version from github actions")
survivalMcMeta = open(root_dir / 'survival/pack.mcmeta', "rt")
survivalData = survivalMcMeta.read()
survivalData = survivalData.replace('vDEV', 'v' + version)
buildMcMeta = open(root_dir / 'build/pack.mcmeta', "rt")
buildData = buildMcMeta.read()
buildData = buildData.replace('vDEV', 'v' + version)
zipS.writestr("pack.mcmeta", survivalData)
zipB.writestr("pack.mcmeta", buildData)
survivalMcMeta.close()
buildMcMeta.close()

print("Add some extra files")
zipB.write(root_dir / "pack.png", "pack.png")
zipB.write(root_dir / "LICENSE", "LICENSE")
zipB.close()
zipS.write(root_dir / "pack.png", "pack.png")
zipS.write(root_dir / "LICENSE", "LICENSE")
zipS.close()
