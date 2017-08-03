import certifi
import urllib3
http = urllib3.PoolManager(
    cert_reqs='CERT_REQUIRED',
    ca_certs=certifi.where())

url_root = "https://api.opendota.com/api/"
i = 0
n_batch = 200
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
entries.append("match_skill.skill")
sql = ' '.join(("SELECT " + ', '.join(entries),
                "FROM matches",
                "WHERE TRUE",
                "AND matches.start_time > 1451606400",
                "AND matches.radiant_win IS NOT NULL",
                "AND matches.picks_bans IS NOT NULL",
                "ORDER BY matches.start_time asc",
                "OFFSET " + str(i),
                "LIMIT " + str(n_batch)
                ))
r = http.request('GET', url_root + "explorer?sql=" + sql)
print(url_root + "explorer?sql=" + sql)
res = r.data
print(res)
