import * as webpack from 'webpack'
import * as path from 'path'
import * as HtmlWebpackPlugin from 'html-webpack-plugin'
import * as CleanWebpackPlugin from 'clean-webpack-plugin'
import * as CopyWebpackPlugin from 'copy-webpack-plugin'
import DtsGeneratorPlugin, {IDtsGeneratorPluginOptions} from 'dts-generator-webpack-plugin';
const dtsGeneratorPluginOptions: IDtsGeneratorPluginOptions = {
        name: 'dotaconstants'
};


const webpackConfig: webpack.Configuration = {
    entry: './src/index.ts',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'app.bundle.js'
    },
    module: {
        loaders: [
            {
                test:    /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader:  'elm-webpack-loader?verbose=true&warn=true',
            },
            {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'url-loader?limit=10000&mimetype=application/font-woff',
            },
            {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'file-loader',
            },
            {
                test: /\.(css|scss)$/,
                use: [
                    'style-loader',
                    'css-loader',
                ]
            },
            {
                test:    /\.(html|json)$/,
                exclude: /node_modules/,
                loader:  'file-loader?name=[name].[ext]',
            },
            // all files with a '.ts' or '.tsx' extension will be handled by 'ts-loader'
            { test: /\.tsx?$/, loader: "ts-loader" }

        ],
        noParse: /\.elm$/,
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
        new DtsGeneratorPlugin(dtsGeneratorPluginOptions)

    ],
    devServer: {
        contentBase: path.join(__dirname, "dist"),
        compress: true,
        host: "0.0.0.0",
        disableHostCheck: true,
        port: 7777
    }
};
export default webpackConfig;
