// document.body.innerHTML += "Welcome to JSHELL"

import {Scalar, Graph, Tensor, SGDOptimizer, CostReduction, Session,
    ENV, NDArray, Array2D, Array1D, InputProvider,
    InGPUMemoryShuffledInputProviderBuilder} from 'deeplearn';
// import { Main } from "./Main.elm";
import * as Elm from './Main'
// import * as hero_id_map from './.json';


function wait(ms:number) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

const hidden_dim = 2
const E: Array2D = Array2D.randUniform([113, hidden_dim], -1, 1)
const Eb: Array1D = Array1D.randUniform([hidden_dim], -1, 1)
const D: Array2D = Array2D.randUniform([hidden_dim, 113], -1, 1)
const Db: Array1D = Array1D.randUniform([113], -1, 1)
// Make new tensors representing the output of the operations of the quadratic.

const math = ENV.math;
const heros_1hot:Array2D = (() => {
    let vec = Array(113*113).fill(false)
    for (let i = 0; i < 113; i++){
        vec[i*113 + i] = true
    }
    return Array2D.new([113, 113], vec)
})()

async function get_herovec(X:Array2D):Promise<number[][]>{
    let hero_vec:number[][] = Array(113)
    let vec_gpu = math.add(math.matMul(X, E), Eb)
    let vec = await vec_gpu.data()
    for (let i = 0; i < 113; i++){
        hero_vec[i] = [vec[vec_gpu.locToIndex([i, 0])],
                       vec[vec_gpu.locToIndex([i, 1])]]
    }
    return hero_vec
}

let pageReady_flag:boolean = false;
const pageReady = new Promise((resolve, reject) => {
    if (pageReady_flag == true) resolve();
});


async function run() {
    const app = Elm.Main.fullscreen();
    let sendHeroVec = (data_: number[][]) => {
        return app.ports.dataIn.send({ tag: "NewHeroVecs", data: {content:  data_} });
    }

    app.ports.dataOut.subscribe(msg => {
        if (msg.tag == "LogError") {
            console.error(msg.data);
        } else if (msg.tag == "PageReady"){
            console.log('PageReady');
            pageReady_flag = true;
        }
    });
    await math.scope(async (keep, track) => {
        sendHeroVec(await get_herovec(heros_1hot));
        console.log(await get_herovec(heros_1hot))
    });

}
run();
