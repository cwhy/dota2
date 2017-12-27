// document.body.innerHTML += "Welcome to JSHELL"

import {Scalar, Graph, Tensor, SGDOptimizer, CostReduction, Session,
	ENV, NDArray,
	InCPUMemoryShuffledInputProviderBuilder} from 'deeplearn';
// import { Main } from "./Main.elm";
import * as Elm from './Main'

// declare function require(path: string): any;
// require('./index.html');


function wait(ms:number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

const graph = new Graph();
// Make a new input in the graph, called 'x', with shape [] (a Scalar).
const x: Tensor = graph.placeholder('x', []);
// Make new variables in the graph, 'a', 'b', 'c' with shape [] and random
// initial values.
const a: Tensor = graph.variable('a', Scalar.new(Math.random()));
const b: Tensor = graph.variable('b', Scalar.new(Math.random()));
const c: Tensor = graph.variable('c', Scalar.new(Math.random()));
// Make new tensors representing the output of the operations of the quadratic.
const order2: Tensor = graph.multiply(a, graph.square(x));
const order1: Tensor = graph.multiply(b, x);
const y: Tensor = graph.add(graph.add(order2, order1), c);

// When training, we need to provide a label and a cost function.
const yLabel: Tensor = graph.placeholder('y label', []);
// Provide a mean squared cost function for training. cost = (y - yLabel)^2
const cost: Tensor = graph.meanSquaredCost(y, yLabel);

// At this point the graph is set up, but has not yet been evaluated.
// **deeplearn.js** needs a Session object to evaluate a graph.
const math = ENV.math;
const session = new Session(graph, math);

// For more information on scope / track, check out the [tutorial on performance](/docs/tutorials/performance.html).
let pageReady_flag:boolean = false;
const pageReady = new Promise((resolve, reject) => {
  if (pageReady_flag == true) resolve();
});
async function run() {
  const app = Elm.Main.fullscreen();
  await wait(0)
  app.ports.dataOut.subscribe(msg => {
      if (msg.tag == "LogError") {
        console.error(msg.data);
      } else if (msg.tag == "PageReady"){
        console.log('PageReady');
        pageReady_flag = true;
      }
  });
  let sendEntry = async (data_: string) => {
    return app.ports.dataIn.send({ tag: "NewData", data: {content:  data_} });
  }
  await math.scope(async (keep, track) => {
  /**
   * Inference
   */
  // Now we ask the graph to evaluate (infer) and give us the result when
  // providing a value 4 for "x".
  // NOTE: "a", "b", and "c" are randomly initialized, so this will give us
  // something random.
  let result: NDArray =
  session.eval(y, [{tensor: x, data: track(Scalar.new(4))}]);
  console.log(result.shape);
  await sendEntry(String(await result.data()));
  console.log('result', await result.data());
  /**
   * Training
   */
  // Now let's learn the coefficients of this quadratic given some data.
  // To do this, we need to provide examples of x and y.
  // The values given here are for values a = 3, b = 2, c = 1, with random
  // noise added to the output so it's not a perfect fit.
  const xs: Scalar[] = [
  track(Scalar.new(0)),
  track(Scalar.new(1)),
  track(Scalar.new(2)),
  track(Scalar.new(3))
  ];
  const ys: Scalar[] = [
  track(Scalar.new(1.1)),
  track(Scalar.new(5.9)),
  track(Scalar.new(16.8)),
  track(Scalar.new(33.9))
  ];
  // When training, it's important to shuffle your data!
  const shuffledInputProviderBuilder =
  new InCPUMemoryShuffledInputProviderBuilder([xs, ys]);
  const [xProvider, yProvider] =
  shuffledInputProviderBuilder.getInputProviders();

  // Training is broken up into batches.
  const NUM_BATCHES = 100;
  const BATCH_SIZE = xs.length;
  // Before we start training, we need to provide an optimizer. This is the
  // object that is responsible for updating weights. The learning rate param
  // is a value that represents how large of a step to make when updating
  // weights. If this is too big, you may overstep and oscillate. If it is too
  // small, the model may take a long time to train.
  const LEARNING_RATE = .01;
  const optimizer = new SGDOptimizer(LEARNING_RATE);
  for (let i = 0; i < NUM_BATCHES; i++) {
    // Train takes a cost tensor to minimize; this call trains one batch and
    // returns the average cost of the batch as a Scalar.
    const costValue = session.train(
      cost,
        // Map input providers to Tensors on the graph.
        [{tensor: x, data: xProvider}, {tensor: yLabel, data: yProvider}],
        BATCH_SIZE, optimizer, CostReduction.MEAN);

   // pageReady
    // await wait(0)
    console.log('average cost: ' + await costValue.data());
    sendEntry(String(await costValue.data()));
  }

  // Now print the value from the trained model for x = 4, should be ~57.0.
  result = session.eval(y, [{tensor: x, data: track(Scalar.new(4))}]);
  console.log('result should be ~57.0:');
  console.log(result.shape);
  console.log(await result.data());
  await sendEntry(String(await result.data()));
});

}
run();