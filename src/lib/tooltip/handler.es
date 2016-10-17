/**
 * Registered tooltips
 * @type {Object}
 */
var tooltips = {}

/**
 * Simple service to register and get Tooltip controllers
 */
class TooltipHandler {

  /**
   * Get a tooltip by id
   * @param  {String} id Tooltip id
   * @return {TooltipCtrl}
   */
  static get (id) {
    return tooltips[id]
  }

  /**
   * Register a new tooltip
   * @param  {String} id Tooltip id
   * @param  {TooltipCtrl} tooltip Tooltip controller
   */
  static register (id, tooltip) {
    if (tooltips[id]) {
      throw new Error(`Tooltip already registered with id "${id}"`)
    } else {
      tooltips[id] = tooltip
    }
  }

  /**
   * Unregister a tooltip
   * @param  {String} id Tooltip id
   */
  static unregister (id) {
    delete tooltips[id]
  }
}

export default TooltipHandler
