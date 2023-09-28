exports.init = async function init(app) {
  // @WARNING: this only runs for Lamdera production deploys!
  // This file will not run in Local development, an equivalent to this is
  // automatically generated in Local Development for every file in elm-pkg-js/

  const eval_js= require('./elm-pkg-js/eval-js.js')

  const test_ports= require('./elm-pkg-js/test-ports.js')

  eval_js.init(app)

  test_ports.init(app)

}
