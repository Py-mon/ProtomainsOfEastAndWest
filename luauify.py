import pathlib

for file in pathlib.Path("src").rglob("*.lua"):
    print("renamed")
    file.rename(file.with_suffix(".luau"))
