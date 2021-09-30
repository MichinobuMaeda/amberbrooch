# Development

## Preriquisites

- Flutter >= 2.5.0
- Node.js >= 14
- [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- curl

```
$ npm -g install yarn
$ git clone git@github.com:MichinobuMaeda/amberbrooch.git
$ cd amberbrooch
$ flutter pub get
$ yarn --cwd functions install
$ yarn install
$ yarn test:functions
$ yarn test:ui
$ yarn serve
```
