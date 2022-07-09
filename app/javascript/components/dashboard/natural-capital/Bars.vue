<template>
  <div class="dashboard-bars">
    <div
      v-if="showLegend"
      class="dashboard-bars__legend"
    >
      <div
        v-for="bar in bars"
        :key="`dashboard-bars-legend-item-${_uid}-${bar.id}`"
        :class="[
          'dashboard-bars__legend-item',
          `dashboard-bars__legend-item--${bar.classModifier}`
        ]"
      >
        <span class="dashboard-bars__legend-text">
          <strong>{{ bar.value }}</strong> {{ bar.label }}
        </span>
      </div>
    </div>

    <ul class="dashboard-bars__bar-items">
      <li
        v-for="bar in bars"
        :key="`dashboard-bars-bar-${_uid}-${bar.id}`"
        class="dashboard-bars__bar-item"
      >
        <bar
          v-bind="{ bar }"
        />
      </li>
    </ul>
  </div>
</template>

<script>
import Bar from './Bar'

export default {
  components: {
    Bar
  },

  props: {
    bars: {
      type: Array,
      default: () => []
    },

    showLegend: {
      type: Boolean,
      default: true
    }
  }
}
</script>
