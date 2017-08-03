import tensorflow as tf
import data_utils as du

batch_size = 100
data_full = du.contents
data_gen = du.get_hero_gen(data_full)
# next(data_gen)
