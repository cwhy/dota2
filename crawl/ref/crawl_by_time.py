import requests
import time
from datetime import datetime
import os


def read_time(ts):
    t_format = '%d-%m-%Y %H:%M:%S'
    return datetime.fromtimestamp(ts).strftime(t_format)

t_start = 1400000000  # 1451606400
url_root = "https://api.opendota.com/api/"
# sql = "select * from matches where match_id=2847256008"
# file_name = 'mode_1_all_pick_' + read_time(t_start)
# file_name = 'mode_2_captains_mode' + read_time(t_start)
file_name = 'mode_22_ranked' + read_time(t_start)
last_t = None
if os.path.isfile(file_name) and os.path.getsize(file_name) > 0:
    with open(file_name) as _f:
        for last_row in _f:
            pass
        last_t = last_row.split(', ')[0]
        last_id = last_row.split(', ')[-1]
        print(last_row)
        print(read_time(int(last_t)))


if last_t:
    t = int(last_t) + 1
else:
    t = t_start

entries = [
    'picks_bans',
    'radiant_win',
    'start_time',
    # 'duration',
    # 'first_blood_time',
    # 'human_players',
    # 'chat',
    # 'version',
    'match_id'
]
# entries = '*'
n_batch = 200

for _i in range(n_batch):
    print('start:', read_time(t))
    if n_batch < 2:
        raise Exception('Too many retries')
    time.sleep(1)
    sql = ' '.join(("SELECT " + ', '.join(entries),
                    "FROM matches",
                    "WHERE TRUE",
                    "AND start_time > " + str(t),
                    "AND game_mode = 22",
                    "AND radiant_win IS NOT NULL",
                    "AND picks_bans IS NOT NULL",
                    "ORDER BY start_time asc",
                    "LIMIT " + str(n_batch)))
    r = requests.get(url_root + "explorer?sql=" + sql)
    print(url_root + "explorer?sql=" + sql)
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
        n_batch //= 2
        continue

    n_batch = 200
    with open(file_name, 'a') as _f:
        for _r in res['rows']:
            # hero_dict = {}
            # for bp in _r['picks_bans']:
            #     s_p = 'p' if bp['is_pick'] else 'b'
            #     win = _r['radiant_win'] ^ bp['team']
            #     stw = 1 if win else -1
            #     if bp['is_pick']:
            #         hero_dict[bp['hero_id']] = stw
            # print(hero_dict)
            # hero_vec = [hero_dict.get(i, 0) for i in range(1, 115)]
            # print(hero_vec)
            heros_w = []
            heros_l = []
            for bp in _r['picks_bans']:
                if bp['is_pick']:
                    if _r['radiant_win'] ^ bp['team']:  # hero of won team
                        heros_w.append(str(bp['hero_id']))
                    else:
                        heros_l.append(str(bp['hero_id']))
            t = _r['start_time']
            herov = ':'.join(heros_w) + '>' + ':'.join(heros_l)
            _f.write(', '.join([str(t), str(_r['match_id']), herov]))
            _f.write('\n')
    print(_i, read_time(t))
