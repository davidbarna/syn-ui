import core from 'syn-core'
import swal from 'sweetalert'

/**
 * Service in charge of displaying messages to user
 */
class UiMessages extends core.messaging.ui.Interface {

  /**
   * Simple façade for sweet alert service
   * @param  {Object} options SweetAlert options
   * @return {undefined}
   */
  _showMessage (options, callback) {
    swal(options, callback)
  }

  /**
   * @see MesssagingUiInterface (syn-core)
  */
  confirm (options) {
    // Avoids message to be closed
    if (options.allowClosure === false) {
      options.closeOnConfirm = false
      options.allowOutsideClick = false
      options.allowEscapeKey = false
    }

    return new Promise((resolve, reject) => {
      this._showMessage(options, (output) => resolve(output))
    })
  }
}

export default UiMessages
