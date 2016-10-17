import {angularify} from 'syn-core'
import TooltipCtrl from './controller'

export default {
  name: 'synTooltip',
  scope: {
    synTooltipVertical: '@',
    synTooltipHorizontal: '@'
  },
  controller: [ '$scope', '$element', (scope, element) => {
    angularify(scope, new TooltipCtrl(
      element, scope.synTooltipHorizontal, scope.synTooltipVertical
    )).init()
  }]
}
