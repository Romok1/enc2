<template>
  <div class="global-overview-averages">
    <div class="global-overview-averages__header">
      <p class="global-overview-averages__intro">
        {{ t.intro }}
      </p>
    </div>
    <div class="global-overview-averages__body">
      <div class="global-overview-averages__columns">
        <div
          v-for="(scale, scaleID) in data"
          :key="scaleID"
          class="global-overview-averages__column"
        >
          <h4 class="global-overview-averages__heading">
            {{ t.charts[scaleID].title }}
          </h4>

          <div class="global-overview-averages__chart">
            <chart-scale
              v-bind="scale"
              class="global-overview-averages__chart-scale"
              :class="`chart-scale--${scaleID}`"
              :title="scaleTitle(scaleID)"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ChartScale from '~/components/chart/ChartScale'

export default {
  components: { ChartScale },

  props: {
    data: {
      type: Object,
      required: true
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.mining.components.global_overview.averages')    
    }
  },

  methods: {
    scaleTitle (scaleID) {
      return scaleID === 'star' ? this.$t('common.scale_log') : this.$t('common.scale')
    }
  }
}
</script>