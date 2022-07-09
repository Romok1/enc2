<template>
  <modal
    class="modal--dashboard"
    :active="active"
    @changed="setModalVisibility"
  >
    <div 
      ref="dashboardModalHeader"
      class="dashboard-modal__header"
    >
      <slot name="header" />
    </div>

    <div 
      class="dashboard-modal__body"
      :style="{ maxHeight: dashboardModalBodyHeight }"
    >
      <slot name="body" />
    </div>

    <div 
      ref="dashboardModalFooter"
      class="dashboard-modal__footer"
    >
      <slot name="footer" />
    </div>
  </modal>
</template>

<script>
import { debounce } from 'lodash'
import { executeAfterCondition } from  '~/helpers/timing-helpers'
import eventHandler from '~/mixins/mixin-element-event-handler'

import Modal from '~/components/modal/Modal'

export default {
  components: { Modal },

  mixins: [
    eventHandler(window, 'resize', debounce(function () {
      this.setDashboardModalBodyHeight()
    }, 50))
  ],

  model: {
    event: 'changed',
    prop: 'active'
  },

  props: {
    active: {
      type: Boolean,
      required: true
    }
  },

  data() {
    return {
      dashboardModalBodyHeight: undefined,
    }
  },

  watch: {
    active (active) {
      if (active) {
        this.waitForRefs(this.setDashboardModalBodyHeight)
      }
    }
  },

  methods: {
    setModalVisibility (active) {
      this.$emit('changed', active)
    },

    setDashboardModalBodyHeight () {
      this.dashboardModalBodyHeight = 'none'

      //We need to wait so that the modal container can expand to maxHeight first
      setTimeout(() => {
        this.dashboardModalBodyHeight = this.getDashboardModalBodyHeight()
      }, 100)
    },

    getDashboardModalBodyHeight () {
      const modalContainer = this.$el.querySelector('.modal__container')
      const modalContainerPaddingY = parseFloat(window.getComputedStyle(modalContainer, null)
        .getPropertyValue('padding-top')) * 2
      const headerHeight = this.$refs.dashboardModalHeader.offsetHeight
      const footerHeight = this.$refs.dashboardModalFooter.offsetHeight
      const modalContainerHeight = modalContainer.offsetHeight

      const height = modalContainerHeight - modalContainerPaddingY - headerHeight - footerHeight

      return `${height}px`
    },

    waitForRefs (successCb) {
      executeAfterCondition({
        conditionCb: () => this.$refs.dashboardModalHeader && this.$refs.dashboardModalFooter,
        successCb,
        maxAttempts: 5,
        intervalSpacing: 100
      })
    }
  }
}
</script>
