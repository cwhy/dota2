// document.body.innerHTML += "Welcome to JSHELL"

import {Scalar, Graph, Tensor, SGDOptimizer, CostReduction, Session,
    ENV, NDArray, Array2D, Array1D, InputProvider,
    InCPUMemoryShuffledInputProviderBuilder} from 'deeplearn';
// import { Main } from "./Main.elm";
import * as Elm from './Main'
// import * as hero_id_map from './.json';
declare function require(path: string): any;
var hero_id_map = require('./hero_id_map.json');
let map_hero_id: (a:string) => number = (a) => hero_id_map[a]

// require('./index.html');


function wait(ms:number) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function get(url:any) : Promise<string> {
    return new Promise<string>((resolve, reject) => {
        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';

        xhr.onreadystatechange = function (event) {
            if (xhr.readyState !== 4) return;
            if (xhr.status >= 200 && xhr.status < 300) {
                resolve(xhr.response);//OK
            } else {
                reject(xhr.statusText);//Error
            }
        };
        xhr.open('GET', url, true);//Async
        xhr.send();
    });
}
const graph = new Graph();
const hidden_dim = 2
const X: Tensor = graph.placeholder('X', [113]);
const Y: Tensor = graph.placeholder('Y label', [113]);
const E: Tensor = graph.variable('E', Array2D.randUniform([113, hidden_dim], -1, 1));
const Eb: Tensor = graph.variable('Eb', Array1D.randUniform([hidden_dim], -1, 1));
const D: Tensor = graph.variable('D', Array2D.randUniform([hidden_dim, 113], -1, 1));
const Db: Tensor = graph.variable('Db', Array1D.randUniform([113], -1, 1));
// Make new tensors representing the output of the operations of the quadratic.
const H: Tensor = graph.add(graph.matmul(X, E), Eb);
const Yhat: Tensor = graph.add(graph.matmul(H, D), Db)

const cost: Tensor = graph.softmaxCrossEntropyCost(Yhat, Y);

const math = ENV.math;
const session = new Session(graph, math);

let pageReady_flag:boolean = false;
const pageReady = new Promise((resolve, reject) => {
    if (pageReady_flag == true) resolve();
});

function parse_matches(matches: any): number[][]{
    let match_parse:(match:any) => number[] = (match) => {
        let draft_str:string = ""
        if (match.radiant_win){
            draft_str = match.radiant_team
        }else{
            draft_str = match.dire_team
        }
        return draft_str.split(',').map((a:string) => map_hero_id(a))
    }
    return matches.map(match_parse)
}

function get_heros(draft_list: number[][]): Array2D{
    let draft_arr = Array2D.zeros([draft_list.length, 113])
    for (let i:number = 0; i < draft_list.length; i++){
        for (let j of draft_list[i]){
            draft_arr.set(1.0, i, j)
        }
    }
    return draft_arr
}

function get_xs_ys(draft_list: number[][]): [Array1D[], Array1D[]]{
    let xs: Array1D[] = []
    let ys: Array1D[] = []
    for (let i:number = 0; i < draft_list.length; i++){
        for (let j:number = 0; j < 5; j++){
            let x = Array1D.zeros([113])
            let y = Array1D.zeros([113])
            let y_idx:number = draft_list[i][j]
            y.set(1.0, y_idx)
            for (let k of draft_list[i]){
                if (k != y_idx) x.set(1.0, k)
            }
            xs.push(x)
            ys.push(y)
        }
    }
    return [xs, ys]
}

async function run() {
    const app = Elm.Main.fullscreen();
    let sendEntry = async (data_: string) => {
        return app.ports.dataIn.send({ tag: "NewData", data: {content:  data_} });
    }

    const data_raw = await get("https://api.opendota.com/api/publicMatches");
    let draft_list:number[][] = parse_matches(data_raw)
    let [Xs, Ys] = get_xs_ys(draft_list)
    async function get_provider(){
        const data_raw = await get("https://api.opendota.com/api/publicMatches?mmr_descending=true");
        let draft_list:number[][] = parse_matches(data_raw)
        let [Xs, Ys] = get_xs_ys(draft_list)
        const shuffledInputProviderBuilder =
            new InCPUMemoryShuffledInputProviderBuilder([Xs, Ys]);
        return shuffledInputProviderBuilder.getInputProviders();
    }
    // (window as any).data_raw = data_raw
    // await sendEntry(String(await data_raw));
    await wait(0)
    app.ports.dataOut.subscribe(msg => {
        if (msg.tag == "LogError") {
            console.error(msg.data);
        } else if (msg.tag == "PageReady"){
            console.log('PageReady');
            pageReady_flag = true;
        }
    });
    await math.scope(async (keep, track) => {
        /**
         * Inference
         */
        let result: NDArray =
            math.sigmoid(session.eval(Yhat, [{tensor: X, data: Xs[0]}]));
        console.log(result.shape);
        console.log('result', await result.data());
        /**
         * Training
         */
        const NUM_BATCHES = 10;
        const BATCH_SIZE = Xs.length;
        const LEARNING_RATE = .01;
        const optimizer = new SGDOptimizer(LEARNING_RATE);
        let [xProvider, yProvider] = await get_provider()
        let cost_val: Float32Array | Int32Array | Uint8Array
        for (let i = 0; i < NUM_BATCHES; i++) {
            const costValue = session.train(
                cost,
                // Map input providers to Tensors on the graph.
                [{tensor: X, data: xProvider}, {tensor: Y, data: yProvider}],
                BATCH_SIZE, optimizer, CostReduction.MEAN);

            [[xProvider, yProvider], cost_val] = await Promise.all([ get_provider(), costValue.data()])
            console.log('average cost: ' + cost_val);
            // pageReady
            // await wait(0)
            // sendEntry(String(await costValue.data()));
        }

        // Now print the value from the trained model for x = 4, should be ~57.0.
        result = math.sigmoid(session.eval(Yhat, [{tensor: X, data: Xs[0]}]));
        console.log(result.shape);
        console.log(await result.data());
        await sendEntry(String(await result.data()));
    });

}
run();
