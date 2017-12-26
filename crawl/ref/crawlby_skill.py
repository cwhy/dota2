import requests
import time
import os

url_root = "https://api.opendota.com/api/"
# sql = "select * from matches where match_id=2847256008"
file_name = 'match_id_nolimit'
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
# entries = '*'
entries = ['matches.' + e for e in entries]
n_batch = 200

while True:
    if n_batch < 2:
        raise Exception('Too many retries')
    print(i)

    time.sleep(1)
    sql = ' '.join(("SELECT " + ', '.join(entries),
                    "FROM (",
                    "match_skill.skill FROM ",
                    "matches LEFT JOIN match_skill ON",
                    "matches.match_id = match_skill.match_id",
                    "WHERE TRUE",
                    "AND matches.start_time > 1451606400",
                    "AND matches.radiant_win IS NOT NULL",
                    "AND matches.picks_bans IS NOT NULL",
                    "ORDER BY matches.start_time asc",
                    "OFFSET " + str(i),
                    "LIMIT " + str(n_batch),
                    ")"))
    r = requests.get(url_root + "explorer?sql=" + sql, verify=False)
    print(url_root + "explorer?sql=" + sql)
    if r.status_code != 200:
        print('STATUS:', r.status_code)
        n_batch //= 2
        continue
    res = r.json()
    if res['err']:
        print('err')
        n_batch //= 2
        continue
    if res['rowCount'] == 0:
        print(res['rowCount'])
        n_batch //= 2
        continue

    n_batch = 200
    with open(file_name, 'a') as _f:
        for j, _r in enumerate(res['rows']):
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
            herov = ':'.join(heros_w) + '>' + ':'.join(heros_l)
            _f.write(', '.join([str(i+j), str(_r['match_id']), herov]))
            _f.write('\n')
    i += n_batch
