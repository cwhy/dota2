import tensorflow as tf
import data_utils as du
import numpy as np
import matplotlib.pyplot as plt
import os

EMBEDDING_DIM = 2
batch_size = 100
n_heros = 113
data_full = du.shuffled_contents
data_gen = du.get_heros_sampler(data_full, batch_size)
x = tf.placeholder(tf.float32, shape=(None, n_heros))
y_label = tf.placeholder(tf.float32, shape=(None, n_heros))

W1 = tf.Variable(tf.random_normal([n_heros, EMBEDDING_DIM]))
b1 = tf.Variable(tf.random_normal([EMBEDDING_DIM]))
hidden_representation = x @ W1 + b1
W2 = tf.Variable(tf.random_normal([EMBEDDING_DIM, n_heros]))
b2 = tf.Variable(tf.random_normal([n_heros]))
prediction = tf.nn.softmax(hidden_representation @ W2 + b2)

loss = tf.reduce_mean(-tf.reduce_sum(y_label * tf.log(prediction), 1))
train_step = tf.train.RMSPropOptimizer(0.01).minimize(loss)

saver = tf.train.Saver()
print([s.name for s in tf.trainable_variables()])
raise Exception('STOP')
sess = tf.Session()
init = tf.global_variables_initializer()
sess.run(init)
n_iters = 3000
# train for n_iter iterations
data_batch = next(data_gen)
x_train, y_train = du.get_cbow_pairs(data_batch)
input_dict = {x: x_train, y_label: y_train}
for _ in range(n_iters):
    sess.run(train_step, feed_dict=input_dict)
    if _ % 30 == 0:
        print('loss is : ', sess.run(loss,
                                     feed_dict=input_dict))
    data_batch = next(data_gen)
    x_train, y_train = du.get_cbow_pairs(data_batch)
    input_dict = {x: x_train, y_label: y_train}
    if _ % 30 == 0:
        print('next loss is : ', sess.run(loss,
                                          feed_dict=input_dict))

all_emb = sess.run(hidden_representation,
                   feed_dict={x: np.eye(n_heros)})
saver.save(sess, './model.ckpt')
fig, ax = plt.subplots()
ax.scatter(all_emb[:, 0], all_emb[:, 1])


for i, txt in enumerate(du.hero_names):
    ax.annotate(txt, (all_emb[i, 0], all_emb[i, 1]))
plt.show()
