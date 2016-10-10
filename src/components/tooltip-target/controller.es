import TooltipHandler from '../../lib/tooltip/handler'

/**
 * Attribute used for id of target tooltip
 * @type {String}
 */
const TARGET_ATTR = 'syn-tooltip-target'

/**
 * Attribute used for tooltip action option
 * @type {String}
 */
const ACTION_ATTR = 'syn-tooltip-action'

/**
 * Tag used tooltip content placeholder
 * @type {String}
 */
const CONTENT_TAG = 'syn-tooltip-content'

/**
 * Name of click action option
 * @type {String}
 */
const CLICK_ACTION = 'click'

/**
 * Links specified tooltip to given element.
 *
 * The tooltip will appear on the target on mouse event.
 *
 * Furthermore, if target contains a syn-tooltip-content tag,
 * its content will be added to tooltip on open.
 */
class TooltipTargetCtrl {

  constructor (element) {
    this.element = element
    this.tooltipId = this.element.attr(TARGET_ATTR)
    this.action = this.element.attr(ACTION_ATTR)
    this.tooltipContents = this.element.find(CONTENT_TAG).css('display', 'none')
    this.listeners = []
  }

  /**
   * Set events for tooltip show/hide logic
   * @return {TooltipTargetCtrl} this
   */
  init () {
    if (this.action === CLICK_ACTION) {
      this.setListener('click', (event) => {
        this.getTooltip().toggle(this.element, this.getContents())
      })
    } else {
      this.setListener('mouseover', (event) => {
        this.getTooltip().open(this.element, this.getContents())
      })
      this.setListener('mouseout', (event) => {
        this.getTooltip().close()
      })
    }
    return this
  }

  /**
   * Get instance of tooltip controller
   * @return {TooltipCtrl}
   */
  getTooltip () {
    return TooltipHandler.get(this.tooltipId)
  }

  /**
   * Get contents in the target to add to the tooltip
   * @return {jqLite}
   */
  getContents () {
    return this.tooltipContents.css('display', '')
  }

  /**
   * Set a listener to keep track of
   * @param {String}   eventName
   * @param {Function} callback
   * @return {TooltipTargetCtrl} this
   */
  setListener (eventName, callback) {
    this.element.on(eventName, callback)
    this.listeners.push({ event: eventName, callback: callback })
    return this
  }

  /**
  * @return {TooltipTargetCtrl} this
  */
  destroy () {
    this.listeners.forEach((obj) => this.element.off(obj.event, obj.callback))
    this.listeners = []
  }
}

export default TooltipTargetCtrl
