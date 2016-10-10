import TooltipPosition from './position'
import Viewport from './viewport'

/**
 * Prefix of all added classes
 * @type {String}
 */
const BASE_CLASS = 'syn-tooltip-position'

/**
 * Positionning types
 * @type {Object}
 */
const POS = {
  TOP: 'top',
  BOTTOM: 'bottom',
  LEFT: 'left',
  RIGHT: 'right',
  CENTER: 'center'
}

/**
 * Tooltip position depending on a DOM element (target) position
 * and on the viewport size
 */
class TooltipPositioner {

  /**
   * @constructor
   * @param  {jQuery} element Tooltip to position
   * @param  {String} horizontal =  'center' Horizontal alignment
   * @param  {String} vertical   =  'top'    Vertical alignment
   */
  constructor (element, horizontal = POS.CENTER, vertical = POS.TOP) {
    this.element = element
    this.verticalAlign = vertical
    this.horizontalAlign = horizontal
    this.positionClasses = []
  }

  /**
   * Sets the position of the tooltip, depending on `target`
   * By default, position is the bottom left corner of the target
   * But it can change depending on available space on viewport and `target` position.
   * If horizontal or vertical params are received, the position is not calculated
   * and is set to the received value.
   *
   * @param {jQuery} target
   */
  setPosition (target) {
    this.tooltipRect = this.element[0].getBoundingClientRect()
    this.targetRect = target[0].getBoundingClientRect()
    this.pos = new TooltipPosition(this.tooltipRect, this.targetRect)
    var horizontal = this.getHorizontalAlign(this.horizontalAlign)
    var vertical = this.getVerticalAlign(this.verticalAlign)

    var props = this.pos[ vertical + horizontal ]()
    this.element.css({ left: props.left + 'px', top: props.top + 'px' })
    this.setClasses(target, vertical, horizontal)
  }

  /**
   * Adds classes depending on tooltip position
   * Use theses classes if the toop tip has design that depending on `target` position
   * @param  {jqLite} target
   * @param  {String} vertical
   * @param  {String} horizontal
   */
  setClasses (target, vertical, horizontal) {
    if (this.positionClasses.length > 0) {
      this.element.removeClass(this.positionClasses.join(' '))
    }

    this.positionClasses = [
      BASE_CLASS + '--' + horizontal,
      BASE_CLASS + '--' + vertical
    ]
    this.element.addClass(this.positionClasses.join(' '))
  }

  /**
   * Get vertical align according to viewport limits
   * @param  {String} vertical 'top', 'bottom'
   * @return {String} 'top', 'bottom'
   */
  getVerticalAlign (vertical) {
    if (this.pos[vertical]() < 0) {
      return POS.BOTTOM
    }
    if ((this.pos[vertical]() + this.tooltipRect.height) > Viewport.height) {
      return POS.TOP
    }
    return vertical
  }

  /**
   * Get horizontal align according to viewport limits
   * @param  {String} horizontal 'left', 'right', 'center'
   * @return {String} 'left', 'right', 'center'
   */
  getHorizontalAlign (horizontal) {
    if (this.pos[horizontal]() < 0) {
      return POS.LEFT
    }
    if ((this.pos[horizontal]() + this.tooltipRect.width) > Viewport.width) {
      return POS.RIGHT
    }
    return horizontal
  }

  /**
   * Remove classes added to target
   */
  destroy () {
    this.element.removeClass(this.positionClasses.join(' '))
  }
}

export default TooltipPositioner
