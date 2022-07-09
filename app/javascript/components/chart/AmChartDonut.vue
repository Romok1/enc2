<template>
  <div 
    class="chart-donut"
    :class="{'chart-donut--no-data': !hasData}"
  >
    <h4
      v-if="title"
      class="chart-donut__title"
    >
      {{ title }}
    </h4>

    <div class="chart-donut__chart-wrapper">
      <div
        :id="chartID"
        class="chart-donut__chart"
      >
        <div 
          v-if="!hasData"
          class="chart-donut__no-data"
        >
          {{ $t('charts.no_data') }}
        </div>
      </div>

      <p
        v-if="hasData"
        class="chart-donut__center-text"
      >
        {{ text.center }}
      </p>
    </div>

    <div 
      v-if="text.caption"
      class="chart-donut__caption"
    >
      <p 
        v-for="(line, index) in text.caption"
        :key="getUniqueVForKey('caption-line', index)"
        class="chart-donut__caption-line"
      >
        {{ line }}
      </p>
    </div>
  </div>
</template>

<script>
import * as am4core from '@amcharts/amcharts4/core'
import {
  PieChart,
  PieSeries,
  Legend
} from '@amcharts/amcharts4/charts'
import am4themes_animated from '@amcharts/amcharts4/themes/animated'
import mixinIds from '~/mixins/mixin-ids'

export default {
  name: 'AmChartDonut',

  mixins: [mixinIds],

  props: {
    title: {
      type: String,
      default: undefined
    },
    data: {
      type: Array,
      default: undefined
    },
    animated: {
      type: Boolean,
      default: true
    },
    text: {
      type: Object,
      default: () => ({})
    },
    legendId: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      chart: undefined,
    }
  },

  computed: {
    chartID () {
      return `chart-donut-${this._uid}`
    },

    hasData () {
      return this.data && this.data.length && this.data.reduce((a, c) => a + c.percentage, 0)
    }
  },

  mounted () {
    if (this.hasData) {
      this.initialiseChart()
    }
  },

  beforeDestroy () {
    if (this.chart) {
      this.chart.dispose()
    }
  },

  methods: {
    initialiseChart () {
      if (this.animated) {
        am4core.useTheme(am4themes_animated)
      }

      if (this.data.every(d => d.color)) {
        am4core.useTheme(this.colorTheme)
      }

      this.chart = this.createChart()
      this.setPieSeries()
      this.setLegendContainer()
      this.setupEvents()
    },

    createChart () {
      const chart = am4core.create(this.chartID, PieChart)

      chart.data = this.data
      // Set outer radius
      chart.radius = am4core.percent(90)
      chart.innerRadius = am4core.percent(60)

      return chart
    },

    setPieSeries () {
      // Add and configure Series
      const pieSeries = this.chart.series.push(new PieSeries())

      pieSeries.dataFields.value = 'percentage'
      pieSeries.dataFields.category = 'label'
      pieSeries.slices.template.stroke = am4core.color('#fff')
      pieSeries.slices.template.strokeWidth = 2
      pieSeries.slices.template.strokeOpacity = 1

      // This creates initial animation
      pieSeries.hiddenState.properties.opacity = 1
      pieSeries.hiddenState.properties.endAngle = -90
      pieSeries.hiddenState.properties.startAngle = -90

      // Remove labels
      pieSeries.labels.template.disabled = true
      pieSeries.ticks.template.disabled = true

      pieSeries.slices.template.tooltipText = '{category}: {value}%'
      pieSeries.tooltip.label.maxWidth = 200
      pieSeries.tooltip.label.wrap = true
      // Remove active click state
      const slice = pieSeries.slices.template

      slice.states.getKey('active').properties.shiftRadius = 0
    },

    colorTheme (target) {
      if (target instanceof am4core.ColorSet) {
        target.list = this.data.map(category => am4core.color(category.color))
      }
    },

    setLegendContainer () {
      // Create legend container
      const legendContainer = am4core.create(this.legendId, am4core.Container)

      legendContainer.width = am4core.percent(100)
      legendContainer.height = am4core.percent(100)
      legendContainer.logo.disabled = true
      legendContainer.textAlign = 'left'
      legendContainer.fontSize = 14

      this.addNewLegendToContainer(legendContainer)
    },

    addNewLegendToContainer (legendContainer) {
      this.chart.legend = new Legend()
      this.chart.legend.parent = legendContainer

      this.chart.legend.contentAlign = 'left'
      this.chart.legend.labels.template.truncate = false
      this.chart.legend.labels.template.wrap = true
      this.chart.legend.labels.template.text = '{category}: {value}%'
      this.chart.legend.valueLabels.template.disabled = true

      const itemContainers = this.chart.legend.itemContainers

      itemContainers.template.paddingTop = 4
      itemContainers.template.paddingBottom = 4

      // Make legend markers round
      const marker = this.chart.legend.markers.template.children.getIndex(0)

      marker.width = 22
      marker.height = 22
      marker.cornerRadius(0, 0, 0, 0)
    },

    setupEvents () {
      this.chart.events.on('datavalidated', this.resizeLegend)
      this.chart.events.on('maxsizechanged', this.resizeLegend)

      this.chart.legend.events.on('datavalidated', this.resizeLegend)
      this.chart.legend.events.on('maxsizechanged', this.resizeLegend)

      this.$root.$on('windowResized', this.resizeLegend)
    },

    resizeLegend () {
      document.getElementById(this.legendId).style.height = this.chart.legend.contentHeight + 'px'
    }
  }
}
</script>
