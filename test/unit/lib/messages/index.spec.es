import Promise from 'bluebird'
import UiMessages from 'src/lib/messages'

describe('messages', function () {
  var messages, options, sandbox

  beforeEach(function () {
    options = {
      title: 'fake title',
      text: 'fake text'
    }
    sandbox = sinon.sandbox.create()
    messages = new UiMessages()
  })

  afterEach(function () {
    sandbox.restore()
  })

  describe('#confirm', function () {
    var result, callback

    beforeEach(function () {
      sandbox.stub(messages, '_showMessage', function (opts, cb) {
        callback = cb
      })
      result = messages.confirm(options)
    })

    it('should call sweet alert with given options', function () {
      messages._showMessage.should.have.been.calledOnce
      messages._showMessage.should.have.been.calledWith(options)
      expect(messages._showMessage.args[0][0].closeOnConfirm).to.be.undefined
    })

    it('should return a promise', function () {
      result.should.be.instanceOf(Promise)
    })

    it('should return a promise resolved on sweet alert callback', function (done) {
      callback('fakeResponse')
      result.then(function (response) {
        response.should.equal('fakeResponse')
        done()
      })
    })

    describe('when options.allowClosure is set to false', function () {
      beforeEach(function () {
        options.allowClosure = false
        messages.confirm(options)
      })

      it('should convert to sweet alert closure options', function () {
        expect(messages._showMessage.args[1][0].closeOnConfirm).to.be.false
        expect(messages._showMessage.args[1][0].allowOutsideClick).to.be.false
        expect(messages._showMessage.args[1][0].allowEscapeKey).to.be.false
      })
    })
  })
})
