import * as tf from '@tensorflow/tfjs';

export {demo, demoDAE}

function createDemo() {
  const input = tf.input({shape: [1], name: "input"});
  const dense2 = tf.layers.dense({units: 8, useBias: true, name: "l2"}).apply(input);
  const a2 = new Mish().apply(dense2);
  const dense3 = tf.layers.dense({units: 1, useBias: true, name: "l3"}).apply(a2);
  return tf.model({inputs: input, outputs: dense3})
}

const demo = createDemo();

const demoAE = tf.sequential({
 layers: [
  tf.layers.dense({inputShape: [2], units: 16, useBias: true, name: "l1"}),
  new Mish(),
  tf.layers.dense({units: 4, useBias: true, name: "l2"}),
  new Mish(),
  tf.layers.dense({units: 2, useBias: true, name: "l3"})
 ]
});

const demoDAE = tf.sequential({
    layers: [
        new GaussianNoise({inputShape: [2], stddev:2}),
        tf.layers.dense({units: 16, useBias: true, name: "l1"}),
        new Mish(),
        tf.layers.dense({units: 2, useBias: true, name: "l2"}),
        new Mish(),
        tf.layers.dense({units: 16, useBias: true, name: "l3"}),
        new Mish(),
        tf.layers.dense({units: 2, useBias: true, name: "l4"})
    ]
});

