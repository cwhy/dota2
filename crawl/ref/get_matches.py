import requests
import time
import os

url_root = "https://api.opendota.com/api/"
# sql = "select * from matches where match_id=2847256008"
file_name = 'match_id_5000'
last_i = None
if os.path.isfile(file_name):
    with open(file_name) as _f:
        for last_row in _f:
            pass
        last_i = last_row.split(', ')[0]
        last_id = last_row.split(', ')[-1]
        print(last_row)
        print(last_i)


if last_i:
    i = int(last_i)
else:
    i = 0

while True:
    print(i)
    time.sleep(1)
    sql = ' '.join(("SELECT * FROM public_matches",
                    "WHERE TRUE",
                    "AND avg_mmr > 5000",
                    "AND start_time > 1451606400",
                    "ORDER BY start_time asc",
                    "OFFSET " + str(i) + " LIMIT 100"))
    r = requests.get(url_root + "explorer?sql=" + sql, verify=False)
    if r.status_code != 200:
        print(r.status_code)
        continue
    res = r.json()
    if res['err']:
        print('err')
        continue
    if res['rowCount'] == 0:
        print(res['rowCount'])
        continue

    with open(file_name, 'a') as _f:
        for j, _r in enumerate(res['rows']):
            _f.write(str(i+j) + ', ' + str(_r['match_id']) + ', ')
            _f.write('\n')
    i += 100
