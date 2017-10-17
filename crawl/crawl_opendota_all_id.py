import requests
import time

url_root = "https://api.opendota.com/api/"
file_name = 'pub_matches'

from_id = 3393281215
match_id = from_id
i = 0

while i < 100:
    time.sleep(0.3)
    match_id = from_id + i
    url = f"https://api.opendota.com/api/matches/{match_id}"
    r = requests.get(url)
    if r.status_code != 200:
        print('ERROR: STATUS:', r.status_code)
    else:
        print('no_skill')
        res = r.json()
        if res['skill'] is not None:
            print(res['skill'])
            print(res['patch'])
            print(res['game_mode'])
            print(res['match_id'])
    i += 1
