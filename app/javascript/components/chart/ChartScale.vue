<template>
  <div class="chart-scale">
    <div class="chart-scale__header">
      <h5 class="chart-scale__heading">
        {{ title }}
      </h5>
      <span class="chart-scale__header-marker chart-scale__header-marker--min">
        {{ min.toLocaleString() }}
      </span>
      <span class="chart-scale__header-marker chart-scale__header-marker--max">
        {{ max.toLocaleString() }}
      </span>
    </div>
    <div class="chart-scale__body">
      <div class="chart-scale__bar">
        <span
          v-for="(marker, index) in markers"
          :key="`chart-scale-marker-${_uid}-${index}`"
          class="chart-scale__marker"
          :class="`chart-scale__marker--${marker.type}`"
          :style="getMarkerPosition(index)"
        />
      </div>
      <div class="chart-scale__legend">
        <ul class="chart-scale__legend-items">
          <li
            v-for="legendItem in legend"
            :key="`scale-legend-${legendItem.name}`"
            class="chart-scale__legend-item"
          >
            <p
              class="chart-scale__legend-label"
              :class="`chart-scale__legend-label--${legendItem.type}`"
            >
              <span class="chart-scale__legend-marker" />
              {{ legendItem.name }}
            </p>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    id: {
      type: String,
      default: undefined
    },
    min: {
      type: Number,
      default: 0
    },
    max: {
      type: Number,
      default: 0
    },
    markers: {
      type: Array,
      required: true
    },
    legend: {
      type: Array,
      default: undefined
    },
    title: {
      type: String,
      default: ''
    }
  },

  computed: {
    range () {
      return this.max - this.min
    }
  },

  methods: {
    getMarkerPosition (markerIndex) {
      const distanceFromMin = this.markers[markerIndex].value - this.min

      return `left: ${(distanceFromMin / this.range) * 100}%`
    }
  }
}
</script>
