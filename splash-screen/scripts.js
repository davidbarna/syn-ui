;(function (doc, global) {
  var headElement = doc.getElementsByTagName('head')[0]

  /**
   * Adds css file to document
   * @param  {String} url Relative url of the file
   * @return {Promise}  Resolved on load
   */
  function injectCss (url) {
    var element = document.createElement('link')
    element.href = url
    element.type = 'text/css'
    element.rel = 'stylesheet'
    return getLoaderPromise(element, url)
  }

  /**
   * Adds js file to document
   * @param  {String} url Relative url of the file
   * @return {Promise}  Resolved on load
   */
  function injectJs (url) {
    var element = document.createElement('script')
    element.src = url
    element.type = 'text/javascript'
    element.async = true
    return getLoaderPromise(element, url)
  }

  /**
   * Takes a script or link element and loads it returning a promise
   * @param  {HTMLElement} element <script> or <link>
   * @param  {String} url Relative url of the file
   * @return {Promise}  Resolved on load
   */
  function getLoaderPromise (element, url) {
    return new Promise(function (resolve, reject) {
      element.onload = function (event) { resolve(url); }
      element.onerror = function (event) { resolve(url); }
      headElement.appendChild(element)
    })
  }

  /**
   * Cleans the splash screen after a time
   */
  function removeSplash () {
    var time = global.env === 'development' ? 0 : 4000
    doc.body.classList.add('-loaded')
    setTimeout((function () {
      document.body.removeChild(doc.getElementById('splash-screen-content'))
    }), time)
  }

  global.syn = global.syn || {}
  global.syn.ui = global.syn.ui || {}
  /**
   * Load all files and remove splashscreen after load
   * @param  {Object} opts Options
   * @param  {String[]} opts.files.css Css files to load
   * @param  {String[]} opts.files.js Js files to load
   * @return {Promise}  Resolve when files are loaded.
   */
  global.syn.ui.splashScreen = function (opts) {
    var promises = []
    if (opts.files && opts.files.css)
      promises = promises.concat(opts.files.css.map(injectCss))
    if (opts.files && opts.files.js)
      promises = promises.concat(opts.files.js.map(injectJs))
    return Promise.all(promises).then(removeSplash)
  }

})(document, window)
