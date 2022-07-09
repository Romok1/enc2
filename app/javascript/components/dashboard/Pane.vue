<template>
  <div
    class="dashboard-pane"
    :class="{ 'dashboard-pane--open': open }"
  >
    <div class="dashboard-pane__header">
      <h3 class="dashboard-pane__title">
        {{ title }}
      </h3>

      <dashboard-tooltip 
        v-if="tooltip"
        :tooltip="tooltip" 
      />
    </div>
    <div class="dashboard-pane__body">
      <slot />
    </div>
  </div>
</template>

<script>
import DashboardTooltip from '~/components/dashboard/DashboardTooltip.vue'

export default {
  name: 'DashboardPanel',

  components: { DashboardTooltip },

  props: {
    title: {
      type: String,
      default: ''
    },
    tooltip: {
      type: String,
      default: ''
    },
    open: {
      type: Boolean,
      deafault: false
    }
  }
}
</script>
