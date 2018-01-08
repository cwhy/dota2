"use strict";
exports.__esModule = true;
var path = require("path");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var CleanWebpackPlugin = require("clean-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var dts_generator_webpack_plugin_1 = require("dts-generator-webpack-plugin");
var dtsGeneratorPluginOptions = {
    name: 'dotaconstants'
};
var webpackConfig = {
    entry: './src/index.ts',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'app.bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack-loader?verbose=true&warn=true'
            },
            {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'url-loader?limit=10000&mimetype=application/font-woff'
            },
            {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'file-loader'
            },
            {
                test: /\.(css|scss)$/,
                use: [
                    'style-loader',
                    'css-loader',
                ]
            },
            {
                test: /\.(html|json)$/,
                exclude: /node_modules/,
                loader: 'file-loader?name=[name].[ext]'
            },
            // all files with a '.ts' or '.tsx' extension will be handled by 'ts-loader'
            { test: /\.tsx?$/, loader: "ts-loader" }
        ],
        noParse: /\.elm$/
    },
    resolve: {
        extensions: ['.js', '.ts', '.json', '.elm']
    },
    plugins: [
        new CleanWebpackPlugin(['dist']),
        new CopyWebpackPlugin([
            { from: 'data', to: 'data' }
        ]),
        new HtmlWebpackPlugin({
            title: 'New App! PogChamp'
        }),
        new dts_generator_webpack_plugin_1["default"](dtsGeneratorPluginOptions)
    ],
    devServer: {
        contentBase: path.join(__dirname, "dist"),
        compress: true,
        host: "0.0.0.0",
        disableHostCheck: true,
        port: 7777
    }
};
exports["default"] = webpackConfig;
