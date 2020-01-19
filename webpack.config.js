const path = require('path')

module.exports = {
    entry: path.join(__dirname, 'src/index.js'),
    output: {
        publicPath: '/',
        filename: 'src/index.js',
    },
    devServer: {
        contentBase: path.join(__dirname),
    },
    mode: 'development',
    module: {
        rules: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack-loader',
                options: {
                    cwd: path.resolve(__dirname),
                    files: [
                        path.resolve(__dirname, 'src/Main.elm'),
                    ],
                },
            },
            {
                test: /\.css$/i,
                use: ['style-loader', 'css-loader'],
            }
        ],
        noParse: [/.elm$/],
    },
}