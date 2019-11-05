import logoUrlF from './assets/logo.svg'
import { Elm } from './elm/Main.elm';
import * as serviceWorker from './js/serviceWorker';
import * as tf from '@tensorflow/tfjs';
import * as tfvis from '@tensorflow/tfjs-vis';
import { getData, convertToTensor } from './js/datautils.js'
// import { demoDAE } from './js/demoModels.js'
// import { trainDemo, sampleDAE } from './js/demoUtils.js'
import {demoGanD, demoGanG, sampleGan, getDemoGanTrainer} from "./js/demoGan";

const app = Elm.Main.init({flags: {logoUrl: logoUrlF}});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

async function run() {
    // Load and plot the original input data that we are going to train on.
    const data = await getData();
    const values = data.map(d => ({
        x: d.horsepower,
        y: d.mpg,
    }));

    tfvis.render.scatterplot(
        {name: 'Horsepower v MPG'},
        {values},
        {
            xLabel: 'Horsepower',
            yLabel: 'MPG',
            height: 300
        }
    );

    // Convert the data to a form we can use for training.
    const tensorData = convertToTensor(data);
    const {inputs, labels} = tensorData;
    const combined = tf.concat([inputs, labels], 1);
    // await console.log(buildCombined);

    // Import model
    // const model = demoDAE;
    tfvis.show.modelSummary({name: 'Generator'}, demoGanG);
    tfvis.show.modelSummary({name: 'Discriminator'}, demoGanD);
    const trainDemoGan = getDemoGanTrainer();

    for (let step = 0; step < 300; step++) {
        await sampleGan(data, tensorData);
        console.log("progress");
        console.log(await trainDemoGan(combined));
    }
    console.log('Done Training');
    // testDemo(model, data, tensorData);
    await sampleGan(data, tensorData);
    // sampleDAE(model, data, tensorData);
}

document.addEventListener('DOMContentLoaded', run);

