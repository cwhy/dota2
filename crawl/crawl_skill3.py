import requests
import time
from datetime import datetime
import os


def read_time(ts):
    t_format = '%d-%m-%Y %H:%M:%S'
    return datetime.fromtimestamp(ts).strftime(t_format)

url_root = "https://api.steampowered.com/IDOTA2Match_570/"
key = "&key=A8684E179D5990C992A718063BA5E047"
url_history = "GetMatchHistory/V001/?skill=3" + key
url_details = "GetMatchDetails/V001/?" + key

file_name = 'ranked_skill_3'

last_id = None
if os.path.isfile(file_name) and os.path.getsize(file_name) > 0:
    with open(file_name) as _f:
        for last_row in _f:
            pass
        last_t = last_row.split(', ')[0]
        last_id = last_row.split(', ')[1]
        print(last_row)
        print(read_time(int(last_t)))


def process_match(match_id, players):
    '''
        ┌─────────────── Team (false if Radiant, true if Dire).
        │ ┌─┬─┬─┬─────── Not used.
        │ │ │ │ │ ┌─┬─┬─ The position of a player within their team (0-4).
        │ │ │ │ │ │ │ │
        0 0 0 0 0 0 0 0
    '''
    heros_r = []
    heros_d = []
    for p in players:
        h_id_str = str(p['hero_id'])
        if p['player_slot'] in range(5):
            heros_r.append(h_id_str)
        elif p['player_slot'] in range(128, 133):
            heros_d.append(h_id_str)
        else:
            raise Exception('player_slot???')
    url = url_root + url_details + "&match_id=" + str(match_id)
    # print(url)
    print('.', end='')
    r = requests.get(url)
    if r.status_code != 200:
        print('MATCH' + str(match_id) + 'ERROR: STATUS:', r.status_code)
        raise Exception('Request failed')
    res = r.json()
    _m = res['result']
    if type(_m['radiant_win']) is bool:
        if _m['radiant_win']:
            herov = ':'.join(heros_r) + '>' + ':'.join(heros_d)
        else:
            herov = ':'.join(heros_d) + '>' + ':'.join(heros_r)
    else:
        raise Exception('no one wins...?')
    t = _m['start_time']
    with open(file_name, 'a') as _f:
        _f.write(', '.join([str(t), str(match_id), herov]))
        _f.write('\n')


n_batch = 10
ln = 0
for _i in range(n_batch):
    time.sleep(1)
    url = url_root + url_history
    if last_id:
        url += "&start_at_match_id=" + str(last_id)
    r = requests.get(url)
    print(url)
    if r.status_code != 200:
        print('ERROR: STATUS:', r.status_code)
        raise Exception('Request failed')
        continue
    res = r.json()
    if not res['result']:
        print(res)
        raise Exception('No results')
    if not res['result']['matches']:
        print(res)
        raise Exception('No results')

    for _ms in res['result']['matches']:
        '''
        lobby_type:
            INVALID = -1;
            CASUAL_MATCH = 0;
            PRACTICE = 1;
            TOURNAMENT = 2;
            COOP_BOT_MATCH = 4;
            LEGACY_TEAM_MATCH = 5;
            LEGACY_SOLO_QUEUE_MATCH = 6;
            COMPETITIVE_MATCH = 7;
            CASUAL_1V1_MATCH = 8;
        '''
        if _ms['lobby_type'] in (0, 5, 7):
            match_id = _ms['match_id']
            t = process_match(match_id, _ms['players'])
            if ln % 12 == 0:
                print(ln)
            ln += 1
            last_id = match_id
        else:
            print('lobby ignored')
    if ln:
        print(_i, read_time(t))
        print('start:', match_id)
