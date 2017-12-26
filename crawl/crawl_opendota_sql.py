import requests
import time
import os

url_root = "https://api.opendota.com/api/"
file_name = 'pro_matches'
last_i = None
if os.path.isfile(file_name) and os.path.getsize(file_name) > 0:
    with open(file_name) as _f:
        for last_row in _f:
            pass
        last_i = last_row.split(', ')[0]
        last_id = last_row.split(', ')[-1]
        print(last_row)
        print(last_i)

if last_i:
    i = int(last_i) + 1
else:
    i = 0
entries = [
    'picks_bans',
    'radiant_win',
    # 'duration',
    # 'first_blood_time',
    # 'human_players',
    # 'chat',
    # 'version',
    'match_id'
]
n_batch = 200
while True:
    print(i)
    time.sleep(0.1)
    if n_batch < 2:
        raise Exception('Too many retries')
    sql = ' '.join(("SELECT " + ', '.join(entries),
                    "FROM matches",
                    "WHERE TRUE",
                    "AND start_time > 1451606400",
                    "AND game_mode = 2",
                    "AND radiant_win IS NOT NULL",
                    "AND picks_bans IS NOT NULL",
                    "ORDER BY start_time asc",
                    "OFFSET " + str(i),
                    "LIMIT " + str(n_batch)))
    r = requests.get(url_root + "explorer?sql=" + sql, verify=False)
    if r.status_code != 200:
        print('ERROR: STATUS:', r.status_code)
        n_batch //= 2
        continue
    res = r.json()
    if res['err']:
        print('ERROR: err')
        n_batch //= 2
        continue
    if res['rowCount'] == 0:
        print('ERROR: rowCount:', res['rowCount'])
        print(res)
        raise
        n_batch //= 2
        continue

    with open(file_name, 'a') as _f:
        for j, _r in enumerate(res['rows']):
            heros_w = []
            heros_l = []
            for bp in _r['picks_bans']:
                if bp['is_pick']:
                    if _r['radiant_win'] ^ bp['team']:  # hero of won team
                        heros_w.append(str(bp['hero_id']))
                    else:
                        heros_l.append(str(bp['hero_id']))
            herov = ':'.join(heros_w) + '>' + ':'.join(heros_l)
            _f.write(', '.join([str(i+j), str(_r['match_id']), herov]))
            _f.write('\n')
    i += n_batch
