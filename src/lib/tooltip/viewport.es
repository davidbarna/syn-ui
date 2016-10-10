/**
 * Margin to apply from actual window limits
 * @type {Number}
 */
const MARGIN = 10

/**
 * If service is already listenning to window changes
 * @type {Boolean}
 */
var isUpdatingLimits = false

/**
 * Service to get width and height of the viewport
 */
class TooltipViewport {

  /**
   * Register event to update viewport width and height
   */
  static registerLimitsUpdater () {
    if (isUpdatingLimits) { return }
    isUpdatingLimits = true
    window.addEventListener('resize', this.updateViewportLimits)
    this.updateViewportLimits()
  }

  /**
   * Unregister event to update viewport width and height
   */
  static unregisterLimitsUpdater () {
    isUpdatingLimits = false
    window.removeEventListener('resize', this.updateViewportLimits)
  }

  /**
   * Take viewport limits and update width and height
   */
  static updateViewportLimits () {
    this.height = document.body.clientHeight - MARGIN
    this.width = document.body.clientWidth - MARGIN
  }

}

TooltipViewport.registerLimitsUpdater()

export default TooltipViewport
