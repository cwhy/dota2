import json

with open('../crawl/match_id_nolimit') as file_:
    contents = []
    for _row in file_.readlines():
        _content = _row.strip('\n').split(', ')[2]
        contents.append(_content)

hero_info = json.load(open('../web/data/dota/build/hero_names.json'))
hero_names = []
elm_gen = """
module Heros exposing (..)

baseImgUrl: String
baseImgUrl = "https://api.opendota.com"

type HeroVec
    = Position { x : Float, y : Float }
    | NoPosition


type alias Hero =
    { name : String
    , iconUrl : String
    , vec : HeroVec
    }


initHeros : List Hero
initHeros =[
"""


def get_elm_str(name, img):
    return f"{{name=\"{name}\"\n,iconUrl=\"{img}\"\n,vec=NoPosition}}\n,"


hero_id_map = dict()
for i, h in enumerate(hero_info.values()):
    hero_names.append(h['localized_name'])
    hero_id_map[str(h['id'])] = i
    elm_gen += get_elm_str(h['localized_name'],
                           h['icon'])
elm_gen = elm_gen[:-1]
elm_gen += ']'

with open('../web/src/Heros.elm', 'w') as f:
    f.write(elm_gen)
