<template>
  <span class="dashboard-bars__bar">
    <span
      :class="[
        'dashboard-bars__bar-fill',
        `dashboard-bars__bar-fill--${bar.classModifier}`
      ]"
      :style="getBarWidthStyling(bar)"
    />
  </span>
</template>

<script>
export default {
  props: {
    bar: {
      type: Object,
      required: true
    }
  },

  methods: {
    getBarWidthStyling (bar) {
      // maxValue not required if value is %
      return { width: bar.value / (bar.maxValue || 100) * 100 + '%' }
    }
  }
}
</script>
