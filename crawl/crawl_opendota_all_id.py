import requests
import sqlite3
import time

conn = sqlite3.connect('pub_matches.db')
url_root = "https://api.opendota.com/api/"
file_name = 'pub_matches'

items = ['match_id', 'skill', 'game_mode', 'patch']

c = conn.cursor()
# c.execute('''CREATE TABLE matches
#             (match_id integer, skill integer, game_mode integer, patch integer)''')

# Insert a row of data


c.execute("SELECT MAX(match_id)  FROM matches")
last_match_id = c.fetchall()[0][0]

# from_id = 3393281310
i = 1
j = 0


def get_sql_items(_l):
    _lm = [f"'{res[i]}'" for i in _l]
    return ','.join(_lm)


patch = None
while i < 10000:
    time.sleep(0.1)
    match_id = last_match_id + i
    url = f"https://api.opendota.com/api/matches/{match_id}"
    r = requests.get(url)
    if r.status_code != 200:
        # print('ERROR: STATUS:', r.status_code)
        print(',', end='', flush=True)
    else:
        res = r.json()
        if (res.get('skill', False) and
                res.get('patch', False) and
                res.get('game_mode', False)):
            if patch != res['patch']:
                patch = res['patch']
                print(patch)
            item_str = get_sql_items(items)
            # print(item_str)
            c.execute(f"INSERT INTO matches VALUES ({item_str})")
            print(res['skill'], end='', flush=True)
            j += 1
        else:
            print('.', end='', flush=True)
        time.sleep(0.2)
    i += 1
    if j % 10 == 0:
        conn.commit()
conn.close()
