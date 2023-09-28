import * as evalJs from './elm-pkg-js/eval-js';
import * as testPorts from './elm-pkg-js/test-ports';

exports.init = async function init(app) {
  // @WARNING: this only runs for Lamdera production deploys!
  // This file will not run in Local development, an equivalent to this is
  // automatically generated in Local Development for every file in elm-pkg-js/

  evalJs.init(app)
  testPorts.init(app)
}
