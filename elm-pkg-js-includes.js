exports.init = async function init(app) {
  // @WARNING: this only runs for Lamdera production deploys!
  // This file will not run in Local development, an equivalent to this is
  // automatically generated in Local Development for every file in elm-pkg-js/
  receiveImageDataFromClipboard.init(app)
  copy_to_clipboard.init(app)

}
