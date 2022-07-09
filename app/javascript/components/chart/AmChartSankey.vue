<template>
  <div class="am-chart--sankey">
    <div class="chartdiv" />
  </div>
</template>

<script>
import * as am4core from '@amcharts/amcharts4/core'
import * as am4charts from '@amcharts/amcharts4/charts'

export default {
  name: 'AmChartSankey',

  props: {
    data: {
      required: true,
      type: Array
    }
  },

  data () {
    return {
      chart: {}
    }
  },

  watch: {
    data () {
      this.updateChartData()
    }
  },

  mounted () {
    this.chartInit()
  },

  methods: {
    chartInit() {
      this.createChart()
      this.createDataFields()
      this.setHoverState()
      this.setStyling()
      this.setTooltips()
    },

    createChart () {
      this.chart = am4core.create('chartdiv', am4charts.SankeyDiagram)
      this.updateChartData()
    },

    createDataFields () {
      this.chart.dataFields.fromName = 'from'
      this.chart.dataFields.toName = 'to'
      this.chart.dataFields.value = 'value'
      this.chart.dataFields.icon = 'icon'
      this.chart.dataFields.iconSVG = 'icon_svg'
      this.chart.dataFields.title = 'title'
      this.chart.dataFields.description = 'description'
    },

    setHoverState () {
      const hoverState = this.chart.links.template.states.create('hover')

      hoverState.properties.fill = am4core.color('#1E2406')
      hoverState.properties.fillOpacity = 1
    },

    setStyling () {
      this.chart.paddingTop = 10
      this.chart.paddingRight = 175
      this.chart.paddingBottom = 40

      this.chart.links.template.colorMode = 'solid'
      this.chart.links.template.fill = am4core.color('#979797')
      this.chart.links.template.hoverOnFocus = true
      this.chart.links.template.cursorOverStyle = am4core.MouseCursorStyle.pointer

      this.chart.nodes.template.interactionsEnabled = false
      this.chart.nodes.template.fill = am4core.color('#54641C')
      this.chart.nodes.template.nameLabel.label.width = 175
      this.chart.nodes.template.nameLabel.label.truncate = true
      this.chart.nodes.template.width = 21
      this.chart.nodes.template.nameLabel.label.fontSize = 14
    },

    setTooltips () {
      this.chart.links.template.tooltipText = '{fromName} > {toName}\n\n{title}: {description}' //IE11 fallback
      this.chart.links.template.tooltipHTML = `
      <div class="sankey__tooltip">
        <span class="sankey__tooltip-flow">{fromName} > {toName}</span>
        <p class="sankey__tooltip-header">  
          <span class="sankey__tooltip-icon {icon}">
            {iconSVG}
          </span>
          <span class="sankey__tooltip-title">{title}</span>
        </p>
        <span class="sankey__tooltip-description">{description}</span>
      </div>`

      this.chart.tooltip.getFillFromObject = false
      this.chart.tooltip.background.cornerRadius = 0
      this.chart.tooltip.background.fill = am4core.color('#fff')
      this.chart.tooltip.background.pointerBaseWidth = 42
      this.chart.tooltip.background.pointerLength = 16
      this.chart.tooltip.background.stroke = am4core.color('#fff')
      this.chart.tooltip.label.fill = am4core.color('#000')
      this.chart.tooltip.label.padding(24,21,24,21)
      this.chart.tooltip.label.wrap = true
      this.chart.tooltip.maxWidth = 428
    },

    updateChartData () {
      this.chart.data = this.data
    }
  }
}
</script>