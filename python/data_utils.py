import numpy as np

with open('../crawl/match_id_nolimit') as file_:
    contents = []
    for _row in file_.readlines():
        _content = _row.strip('\n').split(', ')[2]
        contents.append(_content)


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
    hw = np.zeros((114,))
    hl = np.zeros((114,))
    hw[[int(h) for h in tw.split(':')]] = 1
    hl[[int(h) for h in tl.split(':')]] = 1
    return hw, hl


def hero_gen(_contents, batch_size):
    i = 0
    while True:
        h = np.zeros((batch_size, 114))
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


def draft_gen(_contents, batch_size):
    i = 0
    while True:
        h1 = np.zeros((batch_size, 114))
        h2 = np.zeros((batch_size, 114))
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
    h1 = np.zeros((_size, 114))
    h2 = np.zeros((_size, 114))
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
