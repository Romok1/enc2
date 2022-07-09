<template>
  <div class="dashboard-tooltip">
    <icon-info class="dashboard-tooltip__icon" />

    <span class="dashboard-tooltip__text">
      {{ tooltip }}
    </span>
  </div>
</template>

<script>
import IconInfo from '~/icons/IconInfo'

export default {
  components: { IconInfo },

  props: {
    tooltip: {
      type: String,
      required:true
    }
  }
}
</script>