import TooltipPosition from 'src/lib/tooltip/position'

describe('TooltipPosition', function () {
  beforeEach(function () {
    this.sandbox = sinon.sandbox.create()
    this.instance = new TooltipPosition({
      width: 300,
      height: 200
    }, {
      width: 50,
      height: 60,
      top: 300,
      left: 400
    })
  })
  afterEach(function () {
    this.sandbox.restore()
  })
  describe('#top', function () {
    it('should return position to align tooltip on top', function () {
      this.instance.top().should.equal(100)
    })
  })
  describe('#bottom', function () {
    it('should return position to align tooltip on bottom', function () {
      this.instance.bottom().should.equal(360)
    })
  })
  describe('#left', function () {
    it('should return position to align tooltip on left', function () {
      this.instance.left().should.equal(400)
    })
  })
  describe('#right', function () {
    it('should return position to align tooltip on right', function () {
      this.instance.right().should.equal(150)
    })
  })
  describe('#topleft', function () {
    it('should return position to align tooltip on top left corner', function () {
      this.instance.topleft().top.should.equal(100)
      this.instance.topleft().left.should.equal(400)
    })
  })
  describe('#topright', function () {
    it('should return position to align tooltip on top right corner', function () {
      this.instance.topright().top.should.equal(100)
      this.instance.topright().left.should.equal(150)
    })
  })
  describe('#bottomleft', function () {
    it('should return position to align tooltip on bottom left corner', function () {
      this.instance.bottomleft().top.should.equal(360)
      this.instance.bottomleft().left.should.equal(400)
    })
  })
  describe('#bottomright', function () {
    it('should return position to align tooltip on bottom right corner', function () {
      this.instance.bottomright().top.should.equal(360)
      this.instance.bottomright().left.should.equal(150)
    })
  })
})
