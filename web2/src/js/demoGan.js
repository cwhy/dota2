import * as tf from '@tensorflow/tfjs';
import * as tfvis from '@tensorflow/tfjs-vis';
import { Mish } from './layers.js'

const inputSize = 2;
const latentSize = 4;
const batchSize = 64;
const SOFT_ONE = 0.95;

export const demoGanG = tf.sequential({
    layers: [
        tf.layers.dense({inputShape: [latentSize], units: 8, useBias: true, name: "l1"}),
        new Mish(),
        tf.layers.dense({units: inputSize, useBias: true, name: "l4"})
    ]
});

export const demoGanD = tf.sequential({
    layers: [
        tf.layers.dense({inputShape: [inputSize], units: 8, useBias: true, name: "l1D"}),
        new Mish(),
        tf.layers.dense({units: 16, useBias: true, name: "l2D"}),
        new Mish(),
        tf.layers.dense({units: 32, useBias: true, name: "l3D"}),
        new Mish(),
        tf.layers.dense({units: 1, activation: "sigmoid", useBias: true, name: "l4D"})
    ]
});



export function getDemoGanTrainer() {
    demoGanD.compile({
        loss:['binaryCrossentropy'],
        optimizer: tf.train.adam(0.0001)
    });

    const latent = tf.input({shape: [latentSize]});
    const fake = demoGanG.apply(latent);
    demoGanD.trainable = false;
    const validity = demoGanD.apply(fake);
    const combined =
        tf.model({inputs: [latent], outputs: [validity]});

    combined.compile({
        optimizer: tf.train.adam(0.0001),
        loss: ['binaryCrossentropy']
    });

    async function trainD(data, batchStart, actualBatchSize) {
        demoGanD.trainable = true;
        const [x, y] = tf.tidy(() => {
            const dataBatch = data.slice(batchStart, actualBatchSize);

            // Latent vectors.
            const zVectors = tf.randomNormal([actualBatchSize, latentSize], 0, 1);

            const fakeDataBatch =
                demoGanG.predict([zVectors], {batchSize: actualBatchSize});

            const x = tf.concat([dataBatch, fakeDataBatch], 0);

            const y = tf.tidy(
                () => tf.concat(
                    [tf.ones([actualBatchSize, 1]).mul(SOFT_ONE), tf.zeros([actualBatchSize, 1])]));
            return [x, y];
        });

        const losses = await demoGanD.trainOnBatch(x, y);
        //tf.dispose([x, y]);
        return losses;
    }
    async function trainG(actualBatchSize) {
        demoGanD.trainable = false;
        const [noise, trick] = tf.tidy(() => {
            const zVectors = tf.randomNormal([actualBatchSize, latentSize], 0, 1);

            const trick = tf.tidy(() => tf.ones([actualBatchSize, 1]).mul(SOFT_ONE));
            return [zVectors, trick];
        });

        const losses =
            combined.trainOnBatch([noise], [trick]);
        // tf.dispose([noise, trick]);
        return losses;
    }
    return async (data) => {
        const numBatches = Math.ceil(data.shape[0] / batchSize);
        let dLoss = 0;
        let gLoss = 0;

        for (let batch = 0; batch < numBatches; ++batch) {
            const actualBatchSize = (batch + 1) * batchSize >= data.shape[0] ?
                (data.shape[0] - batch * batchSize) : batchSize;
            gLoss += (await trainG(actualBatchSize));
            dLoss += (await trainD(data, batch * batchSize, actualBatchSize));
        }
        return [dLoss, gLoss]
    };
}

export async function sampleGan(inputData, normalizationData) {
    const {inputMax, inputMin, labelMin, labelMax} = normalizationData;

    // Generate predictions for a uniform range of numbers between 0 and 1;
    // We un-normalize the data by doing the inverse of the min-max scaling
    // that we did earlier.
    const unormalize = (data) => tf.tidy(() => {
        const [pred_xs, pred_ys] = tf.unstack(data, 1);

        const unNormXs = pred_xs
            .mul(inputMax.sub(inputMin))
            .add(inputMin);

        const unNormPreds = pred_ys
            .mul(labelMax.sub(labelMin))
            .add(labelMin);

        // Un-normalize the data
        return [unNormXs.dataSync(), unNormPreds.dataSync()];
    });

    // const [posX, posY, negX, negY] = tf.tidy(async () => {
    //     const preds = demoGanG.predict(tf.randomUniform([200, latentSize], -1, 1));
    //     const validity = demoGanD.predict(preds);
    //     const posPreds = await tf.booleanMaskAsync(preds, tf.greater(validity.squeeze(), 0.5), 0);
    //     const negPreds = await tf.booleanMaskAsync(preds, tf.greater(validity.squeeze(), 0.5), 0);
    //     console.log(tf.greater(posPreds, 0.5));
    //     const [_posX, _posY] = unormalize(posPreds);
    //     const [_negX, _negY] = unormalize(negPreds);
    //     return [_posX, _posY, _negX, _negY];
    // });
    const preds = demoGanG.predict(tf.randomUniform([200, latentSize], -1, 1));
    const validity = demoGanD.predict(preds);
    const posPreds = await tf.booleanMaskAsync(preds, tf.greater(validity.squeeze(), 0.5), 0);
    const negPreds = await tf.booleanMaskAsync(preds, tf.less(validity.squeeze(), 0.5), 0);
    const [posX, posY] = unormalize(posPreds);
    const [negX, negY] = unormalize(negPreds);


    const seriesPos = Array.from(posX).map((val, i) => {
        return {x: val, y: posY[i]}
    });
    const seriesNeg = Array.from(negX).map((val, i) => {
        return {x: val, y: negY[i]}
    });

    const originalPoints = inputData.map(d => ({
        x: d.horsepower, y: d.mpg,
    }));

    tfvis.render.scatterplot(
        {name: 'Model Predictions vs Original Data'},
        {values: [originalPoints, seriesPos, seriesNeg], series: ['original', 'predictedPos', 'predictedNeg']},
        {
            xLabel: 'Horsepower',
            yLabel: 'MPG',
            height: 300
        }
    );
}
