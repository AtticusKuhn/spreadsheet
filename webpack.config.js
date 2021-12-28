var path = require('path');
// Import the plugin:
var DashboardPlugin = require('webpack-dashboard/plugin');
module.exports = [{
    entry: {
        index: "./app/index.imba"
    },
    plugins: [
        new DashboardPlugin()
    ],
    resolve: {
        extensions: [".imba", ".js", ".json"],
        alias: {
            imba: path.resolve(__dirname, 'node_modules', 'imba')
        }
    },

    module: {
        rules: [{
            test: /\.imba$/,
            loader: 'imba/loader'
        }]
    },

    devServer: {
        contentBase: path.resolve(__dirname, 'public'),
        watchContentBase: true,
        historyApiFallback: {
            index: '/index.html'
        },
        compress: true,
        port: 9000,
        https: false
    },

    output: {
        path: path.resolve(__dirname, 'public'),
        filename: '[name].js'
    }
}]