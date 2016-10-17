class TooltipPosition {

  /**
   * `tooltip` and `target` are objects that should contain
   * following porperties: top, left, width, height
   * @param  {[type]} tooltip [description]
   * @param  {[type]} target  [description]
   * @return {[type]}         [description]
   */
  constructor (tooltip, target) {
    this.tooltip = tooltip
    this.target = target
  }

  top () {
    return (this.target.top - this.tooltip.height)
  }

  bottom () {
    return (this.target.top + this.target.height)
  }

  left () {
    return (this.target.left)
  }

  right () {
    return (this.target.left + this.target.width - this.tooltip.width)
  }

  center () {
    return (this.target.left - this.tooltip.width / 2 + this.target.width / 2)
  }

  // Position to align tooltip on top left of target
  topleft () {
    return { top: this.top(), left: this.left() }
  }

  // Position to align tooltip on top right of target
  topright () {
    return { top: this.top(), left: this.right() }
  }

  // Position to align tooltip on top centered on target
  topcenter () {
    return { top: this.top(), left: this.center() }
  }

  // Position to align tooltip on bottom right of target
  bottomright () {
    return { top: this.bottom(), left: this.right() }
  }

  // Position to align tooltip on bottom left of target
  bottomleft () {
    return { top: this.bottom(), left: this.left() }
  }

  // Position to align tooltip on bottom centered on target
  bottomcenter () {
    return { top: this.bottom(), left: this.center() }
  }

}

export default TooltipPosition
