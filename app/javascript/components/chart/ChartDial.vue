<template>
  <div 
    class="chart-dial"
    :class="{ 'chart-dial--no-data': !hasData }"
  >
    <h4
      v-if="title"
      class="chart-dial__title"
    >
      {{ title }}
    </h4>

    <div class="chart-dial__chart-wrapper">
      <div class="chart-dial__chart">
        <Dial
          v-if="hasData"
          :data="data"
        />

        <div 
          v-else 
          class="chart-dial__no-data"
        >
          {{ $t('charts.no_data') }}
        </div>
      </div>

      <p
        v-if="hasData"
        class="chart-dial__center-text"
      >
        {{ text.center }}
      </p>
    </div>

    <div 
      v-if="text.caption"
      class="chart-dial__caption"
    >
      <p 
        v-for="(line, index) in text.caption"
        :key="getUniqueVForKey('caption-line', index)"
        class="chart-dial__caption-line"
      >
        {{ line }}
      </p>
    </div>

    <ul 
      v-if="legend.length && hasData"
      class="chart-dial__legend"
    >
      <li 
        v-for="(line, index) in legend"
        :key="getUniqueVForKey('legend-item', index)"
        class="chart-dial__legend-item"
      >
        {{ line }}
      </li>
    </ul>
  </div>
</template>

<script>
import Dial from '~/components/chart/Dial'
import mixinIds from '~/mixins/mixin-ids'

export default {
  name: 'ChartDial',

  components: { Dial },

  mixins: [mixinIds],

  props: {
    title: {
      type: String,
      default: undefined
    },
    data: {
      type: Object,
      default: undefined
    },
    legend: {
      type: Array,
      default: () => []
    },
    text: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      chart: undefined,
    }
  },

  computed: {
    hasData () {
      return this.data && this.data.value && this.data.max
    }
  }
}
</script>
