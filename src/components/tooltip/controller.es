import { element } from 'angular-bsfy'
import TooltipHandler from '../../lib/tooltip/handler'
import TooltipPositioner from '../../lib/tooltip/positioner'

/**
 * Attribute used for tooltip component
 * @type {String}
 */
const TOOLTIP_ATTR = 'syn-tooltip'

/**
 * Css top position to hide the tooltip
 * @type {String}
 */
const HIDDEN_TOP = '-99999px'

/**
 * DOM Element to place discarded tooltip contents.
 * If they where simply removed from DOM, contents would loose
 * all events listeners assign to them
 * @type {jqLite}
 */
var contentsHolder = null

/**
 * Shows/hide and place the element near to a target
 * The element is placed on top/center of target by default.
 * But in case target is near to viewport border, it is displaced
 */
class TooltipCtrl {

  constructor (element, horizontal, vertical) {
    /**
     * @type {jqLite}
     */
    this.element = element

    /**
     * @type {jqLite}
     */
    this.target = null

    /**
     * @type {TooltipPositioner}
     */
    this.positioner = new TooltipPositioner(this.element, horizontal, vertical)

    /**
     * If Tooltip is open
     * @type {Boolean}
     */
    this.isOpen = false

    /**
     * If scroll event is registered
     * @type {Boolean}
     */
    this.hasEventsListeners = false

    /**
     * Callback for scroll event
     * @type {Function}
     */
    this._update = this.update.bind(this)
  }

  /**
   * Tooltip is registered so it can be retrieved by a target
   */
  init () {
    if (!contentsHolder) {
      contentsHolder = element(document.createElement('DIV'))
        .attr('id', 'syn-tooltip-contents-holder')
        .css('display', 'none')
      document.body.appendChild(contentsHolder[0])
    }

    TooltipHandler.register(this.element.attr(TOOLTIP_ATTR), this)

    // Tooltip is fixed and placed in root element
    this.element.css({ position: 'fixed', top: HIDDEN_TOP })
    document.body.appendChild(this.element[0])
  }

  /**
   * Open the tooltip and place it on target
   * @param  {jqLite} target
   * @param  {lqLite} contents Contents to add to tooltip as content
   * @return {TooltipCtrl} this
   */
  open (target, contents) {
    this.isOpen = true
    this.target = target

    contents && this.contents(contents)
    this.update()

    if (!this.hasEventsListeners) {
      this.hasEventsListeners = true
      window.addEventListener('scroll', this._update)
    }
    return this
  }

  /**
   * Hide the tooltip
   * @return {TooltipCtrl} this
   */
  close () {
    this.isOpen = false
    this.element.css({ top: HIDDEN_TOP })

    if (this.hasEventsListeners) {
      this.hasEventsListeners = false
      window.removeEventListener('scroll', this._update)
    }
    return this
  }

  /**
   * Open tooltip if close. Close tooltip if open.
   * @param  {jqLite} target
   * @param  {lqLite} contents Contents to add to tooltip as content
   * @return {TooltipCtrl} this
   */
  toggle (target, contents) {
    if (this.target !== target) {
      this.close()
    }
    this.isOpen ? this.close() : this.open(target, contents)
  }

  /**
   * Add given contents to tooltip element
   * @param  {jqLite} contents
   * @return {TooltipCtrl} this
   */
  contents (contents) {
    if (!this.content) {
      this.content = element(document.createElement('DIV'))
      this.element.append(this.content)
    }

    contentsHolder.append(this.content.contents())
    this.content.append(contents)
    return this
  }

  /**
   * Update position and style of tooltip
   * @return {TooltipCtrl} this
   */
  update () {
    this.positioner.setPosition(this.target)
    return this
  }

  /**
   * @return {TooltipCtrl} this
   */
  destroy () {
    this.close()
    this.content && this.content.remove()
    this.positioner && this.positioner.destroy()
    TooltipHandler.unregister(this.element.attr(TOOLTIP_ATTR))
    return this
  }
}

export default TooltipCtrl
