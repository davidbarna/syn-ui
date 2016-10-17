import $ from 'jqlite'
import TooltipPosition from 'src/lib/tooltip/position'
import TooltipPositioner from 'src/lib/tooltip/positioner'

describe('TooltipPositioner', function () {
  var $target, $layout, $tooltip, instance, sandbox

  const BASE_CLASS = 'syn-tooltip-position'

  beforeEach(function () {
    sandbox = sinon.sandbox.create()
    $layout = $('<div style="width: 800px; height: 600px;"/>')
    $tooltip = $('<div style="width: 300px; height: 200px;" />')
    $target = $('<button style="position: absolute; width: 50px; height: 50px;" />')
    $(document.body).append($tooltip).append($target).append($layout)
    instance = new TooltipPositioner($tooltip)
  })
  afterEach(function () {
    sandbox.restore()
    $layout.remove()
    $tooltip.remove()
    $target.remove()
  })
  describe('#setPosition', function () {
    beforeEach(function () {
      sandbox.spy($tooltip, 'css')
      sandbox.spy(TooltipPosition.prototype, 'topleft')
      sandbox.spy(TooltipPosition.prototype, 'topright')
      sandbox.spy(TooltipPosition.prototype, 'bottomright')
      sandbox.spy(TooltipPosition.prototype, 'bottomleft')
    })
    describe('when target is at top left', function () {
      beforeEach(function () {
        $target.css({
          top: 0,
          left: 0
        })
        instance.setPosition($target)
      })
      it('should align tooltip to bottom left', function () {
        var bottomLeft
        bottomLeft = TooltipPosition.prototype.bottomleft
        bottomLeft.should.have.been.calledOnce
        instance.element.css.args[0][0].top.should.equal(bottomLeft.returnValues[0].top + 'px')
        instance.element.css.args[0][0].left.should.equal(bottomLeft.returnValues[0].left + 'px')
      })
    })
    describe('when target is at bottom left', function () {
      beforeEach(function () {
        $target.css({
          bottom: 0,
          left: 0
        })
        instance.setPosition($target)
      })
      it('should align tooltip to top left', function () {
        var topLeft
        topLeft = TooltipPosition.prototype.topleft
        topLeft.should.have.been.calledOnce
        instance.element.css.args[0][0].top.should.equal(topLeft.returnValues[0].top + 'px')
        instance.element.css.args[0][0].left.should.equal(topLeft.returnValues[0].left + 'px')
      })
    })
    describe('when target is at top right', function () {
      beforeEach(function () {
        $target.css({
          top: 0,
          right: 0
        })
        instance.setPosition($target)
      })
      it('should align tooltip to bottom right', function () {
        var bottomRight
        bottomRight = TooltipPosition.prototype.bottomright
        bottomRight.should.have.been.calledOnce
        instance.element.css.args[0][0].top.should.equal(bottomRight.returnValues[0].top + 'px')
        instance.element.css.args[0][0].left.should.equal(bottomRight.returnValues[0].left + 'px')
      })
    })
    describe('when target is at bottom right', function () {
      beforeEach(function () {
        $target.css({
          bottom: 0,
          right: 0
        })
        instance.setPosition($target)
      })
      it('should align tooltip to top right', function () {
        var topRight
        topRight = TooltipPosition.prototype.topright
        topRight.should.have.been.calledOnce
        instance.element.css.args[0][0].top.should.equal(topRight.returnValues[0].top + 'px')
        instance.element.css.args[0][0].left.should.equal(topRight.returnValues[0].left + 'px')
      })
      it('should add classes to target', function () {
        $tooltip.hasClass(BASE_CLASS + '--top').should.equal(true)
        $tooltip.hasClass(BASE_CLASS + '--right').should.equal(true)
        $tooltip.hasClass(BASE_CLASS + '--bottom').should.equal(false)
        $tooltip.hasClass(BASE_CLASS + '--left').should.equal(false)
      })
    })
  })
})
