# Client
Since Phoenix 1.4 is migrating to webpack, this package was build with Webpack in mind. If you use Brunch follow the [brunch guide](https://brunch.io/docs/getting-started#including-third-party-ingredients) to import third party packages.

## Installation

The package can be installed by adding `frankt` to your list of dependencies in `mix.exs`:

### 1. Declare the mix dependency

Ensure frankt package is installed or follow the hex package [installation instructions](./README.md.html#installing-frankt).

### 2. Add the javascript dependency to package.json

In order to use frankt, a provided javascript file mus be included in your `package.json` file in the dependencies section. It might look like this:

```js
{
  "dependencies": {
    "phoenix": "file:./deps/phoenix",
    "phoenix_html": "file:./deps/phoenix_html",
    "frankt": "file:./deps/frankt"
  }
}
```

Ther run (from your `assets` directory)

```
$ npm install
```

### 4. Import and initialize the javascript helper

In your main application javascript file (usually `app.js`), add the following line:

```js
import * as Frankt from 'frankt';
```

## Methods

How to push data to frankt

## How to extend

Create a new actions for open modal
