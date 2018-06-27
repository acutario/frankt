const webpack = require('webpack');
const path = require('path');

const isProd = process.env.NODE_ENV === 'production';
const isTest = process.env.NODE_ENV === 'test';

const autoprefixer = require('autoprefixer');
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const source_path = path.join(__dirname, 'test', 'support', 'test_application_web', 'assets');
const output_path = path.join(__dirname, 'test', 'support', 'test_application_web', 'priv', 'static');

const plugins = [
  new MiniCssExtractPlugin({
    filename: "css/[name].css",
    chunkFilename: "css/[id].css"
  }),
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  }),
];

const optimization = {
  namedModules: true,
  splitChunks: {
    chunks: 'async',
    minSize: 15000,
    minChunks: 1,
    maxAsyncRequests: 5,
    maxInitialRequests: 3,
    cacheGroups: {
      vendor: {
        name: 'vendor',
        chunks: 'initial',
        minChunks: 2
      }
    }
  },
  concatenateModules: true,
  minimizer: []
};

if (isProd) {
  optimization.minimizer.push(
    new UglifyJsPlugin({
      parallel: true,
      cache: true,
      uglifyOptions: {
        mangle: {
          safari10: true
        },
        compress: {
          drop_console: true
        },
      },
      extractComments: true
    })
  );
};

module.exports = {
  mode: isProd ? 'production' : 'development',
  devtool: isProd ? false : 'source-map',
  watchOptions: {
    ignored: /node_modules/
  },
  plugins,
  optimization,
  context: source_path,
  entry: {
    app: ['./app.scss', './app.js'],
  },

  output: {
    path: output_path,
    filename: 'js/[name].js',
    chunkFilename: 'js/[name].js',
    publicPath: '/'
  },

  resolve: {
    modules: [
      path.join(__dirname, 'priv', 'static'),
      path.join(source_path, 'test', 'support', 'test_application', 'assets'),
      'node_modules'
    ],
    extensions: ['.js', '.scss']
  },

  module: {
    rules: [{
      test: /\.(js|jsx)$/,
      exclude: /node_modules/,
      use: [
        'babel-loader',
      ]
    },
    {
      test: /\.scss$/,
      exclude: /node_modules/,
      use: [
        MiniCssExtractPlugin.loader,
        'css-loader?sourceMap',
        'postcss-loader?sourceMap',
        'sass-loader?sourceMap',
      ],
    },
    {
      test: /\.(woff2?|eot|ttf|otf|svg)(\?.*)?$/,
      loader: 'url-loader',
      options: {
        limit: 1000,
        name: 'fonts/[name].[hash:7].[ext]'
      }
    }]
  }
};
