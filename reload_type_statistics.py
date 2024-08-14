import json


def get_type_chart():
    def remove_comments(content):
        comment = content.find("--")
        while comment != -1:
            end = content.find("\n", comment)
            content = content[:comment] + content[end:]
            comment = content.find("--")
        return content

    with open(
        r"src\ServerStorage\Modules\Protomain\Battle\Types\TypeChart\init.luau", "r"
    ) as f:
        content = f.read()
        content = (
            remove_comments(content[content.find("{") :])
            .replace(" ", "")
            .replace("{", "[")
            .replace("}", "]")
        )
        return eval(content)


type_chart = get_type_chart()

number_of_types = 0
super_effectives = 0
for row in type_chart:
    number_of_types += 1
    for effectiveness in row:
        if effectiveness == 2:
            super_effectives += 1


def edit_property_value(file, new_value):
    with open(
        file,
        "r+",
    ) as f:
        data = json.load(f)
        data["properties"]["Value"] = new_value  # <--- add `id` value.
        f.seek(0)  # <--- should reset file position to the beginning.
        json.dump(data, f, indent=4)
        f.truncate()  # remove remaining part


edit_property_value(
    r"src\ServerStorage\Modules\Protomain\Battle\Types\TypeChart\Statistics\NumberOfTypes.model.json",
    number_of_types,
)
edit_property_value(
    r"src\ServerStorage\Modules\Protomain\Battle\Types\TypeChart\Statistics\SuperEffectiveChance.model.json",
    number_of_types / super_effectives,
)
