import numpy as np
import json

with open('../crawl/match_id_nolimit') as file_:
    contents = []
    for _row in file_.readlines():
        _content = _row.strip('\n').split(', ')[2]
        contents.append(_content)

hero_info = json.load(open('../constants/hero_names.json'))
hero_names = []
hero_id_map = dict()
for i, h in enumerate(hero_info.values()):
    hero_names.append(h['localized_name'])
    hero_id_map[str(h['id'])] = i


def shuffle_list(_l):
    indices = np.random.permutation(len(contents))
    return [_l[i] for i in indices]


shuffled_contents = shuffle_list(contents)


# test_size = 1000
# test_id = list(np.random.randint(len(content), size=test_size))
# tr_id = [i for i in range(len(content)) if i not in test_id]
# content_test = [content[i] for i in test_id]
# content_tr = [content[i] for i in tr_id]


def parse(_c):
    [tw, tl] = _c.split('>')
    hw = np.zeros((113,))
    hl = np.zeros((113,))
    hw[[hero_id_map[h] for h in tw.split(':')]] = 1
    hl[[hero_id_map[h] for h in tl.split(':')]] = 1
    return hw, hl


def parse_1hot(_c):
    [tw, tl] = _c.split('>')
    hw = np.zeros((113, 5))
    hl = np.zeros((113, 5))
    for i, h in enumerate(tw.split(':')):
        hw[hero_id_map[h], i] = 1
    for i, h in enumerate(tl.split(':')):
        hl[hero_id_map[h], i] = 1
    return hw, hl


def get_heros_sampler(_contents, batch_size):
    len_c = len(_contents)
    _carray = np.array(_contents)
    while True:
        h = np.zeros((batch_size, 113, 5))
        idx = np.random.choice(a=len_c, size=batch_size // 2)
        for i, _match in enumerate(_carray[idx]):
            h[i * 2, :, :], h[i * 2 + 1, :, :] = parse_1hot(_match)

        yield h


def get_cbow_pairs(hs):
    cbow_xs = []
    cbow_ys = []
    for i in range(5):
        yi = hs[:, :, i]
        xi = np.sum(np.delete(hs, i, axis=2), axis=2)
        cbow_xs.append(xi)
        cbow_ys.append(yi)
    return np.concatenate(cbow_xs, axis=0), np.concatenate(cbow_ys, axis=0)


def draft_gen(_contents, batch_size):
    i = 0
    while True:
        h1 = np.zeros((batch_size, 113))
        h2 = np.zeros((batch_size, 113))
        win = np.zeros((batch_size, 1))
        for j in range(batch_size // 2):
            _c = _contents[(i + j) % len(_contents)]
            hw, hl = parse(_c)
            h1[2 * j, :] = hw
            h2[2 * j, :] = hl
            win[2 * j, 0] = 1
            h1[2 * j + 1, :] = hl
            h2[2 * j + 1, :] = hw
        i += 1

        idx = np.random.permutation(batch_size)
        yield h1[idx, :], h2[idx, :], win[idx]


def get_all_drafts(_contents):
    _size = _contents.shape[0]
    h1 = np.zeros((_size, 113))
    h2 = np.zeros((_size, 113))
    win = np.zeros((_size, 1))
    for j in range(_size // 2):
        _c = _contents[j]
        hw, hl = parse(_c)
        h1[2 * j, :] = hw
        h2[2 * j, :] = hl
        win[2 * j, 0] = 1
        h1[2 * j + 1, :] = hl
        h2[2 * j + 1, :] = hw
    return h1, h2, win
