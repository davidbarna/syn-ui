import {angularify} from 'syn-core'
import TooltipTargetCtrl from './controller'

export default {
  name: 'synTooltip',
  controller: [ '$scope', '$element', (scope, element) => {
    angularify(scope, new TooltipTargetCtrl(element)).init()
  }]
}
