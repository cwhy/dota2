import * as tf from '@tensorflow/tfjs';

export class Mish extends tf.layers.Layer {
    // Every layer needs a unique name.
    static className = 'Mish';
    constructor() {
        super({});
    }
    computeOutputShape(inputShape) { return inputShape; }

    // call() is where we do the computation.
    call(input, kwargs) {
        return tf.tidy(() => {
            return tf.mul(tf.tanh(tf.softplus(input[0])), input[0])
        });
    }
}
tf.serialization.registerClass(Mish);

export class GaussianNoise extends tf.layers.Layer {
    static className = 'GaussianNoise';

    constructor(args) {
        super(args);
        this.stddev = args.stddev;
    }

    computeOutputShape(inputShape){
        return inputShape;
    }

    getConfig() {
        const baseConfig = super.getConfig();
        const config = {stddev: this.stddev};
        Object.assign(config, baseConfig);
        return config;
    }

    call(inputs, kwargs) {
        return tf.tidy(() => {
            const input = inputs[0];
            return tf.randomNormal(input.shape, 0, this.stddev).add(input);
        });
    }
}
tf.serialization.registerClass(GaussianNoise);

