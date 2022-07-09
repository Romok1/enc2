<template>
  <div class="dial">
    <svg 
      xmlns="http://www.w3.org/2000/svg" 
      preserveAspectRatio="xMidYMid"
      class="dial__svg" 
      width="100%" 
      height="100%" 
      :viewBox="`${svgStartX} ${svgStartY} ${svgWidth} ${svgHeight}`" 
    >
      <defs>
        <marker 
          id="arrow" 
          class="dial__dial"
          viewBox="0 0 10 14" 
          refX="0" 
          refY="7"
          :markerWidth="dialSize" 
          :markerHeight="dialSize * 14/10"
          orient="auto"
        >
          <path d="M 0 0 L 10 7 L 0 14 z" />
        </marker>

        <filter id="blurFilter">
          <feGaussianBlur stdDeviation="4" />
        </filter>
      </defs>

      <!-- make positive y upwards to fit with polar coordinates -->
      <g transform="scale(1, -1)">
        <path 
          v-for="n in data.max"
          :key="getUniqueVForKey('arc', n)"
          :class="`dial__arc dial__arc--${n}`"
          :d="getArcSectionPath(n)"
        />

        <polyline 
          class="dial__line"
          :points="arrowPoints" 
          fill="none"
          stroke="transparent"
          marker-end="url(#arrow)"
        />

        <circle
          cy="-2"
          :r="circleRadius-2"
          opacity="0.5"
          filter="url(#blurFilter)"
        />

        <circle
          :r="circleRadius"
          class="dial__circle"
        />
      </g>
    </svg>
  </div>  
</template>

<script>
/**
 * x = 0, y = 0 is the centre of the svg. Note the dial <g> is flipped in the y direction
 * which means sin(angleFromHorizontalLineToTheRight) = y/x as expected for polar coords
 */

import { mixinResponsive } from '~/mixins/mixin-responsive'
import mixinIds from '~/mixins/mixin-ids'

const DIAL_ARC_OVERLAP = 3

export default {
  name: 'Dial',

  mixins: [mixinResponsive, mixinIds],

  props: {
    data: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      arcWidth: 34,
      circleRadius: 100,
      dialRangeInDegrees: 240,
      paddingTop: 10,
      paddingBottom: 10,
      paddingSides: 10,
      arcSectionDividerPercent: 1.2,
      dialArcGap: 4
    }
  },

  computed: {
    width () {
      return 2 * (this.circleRadius + this.arcWidth)
    },

    svgStartX () {
      return -this.width/2 - this.paddingSides
    },

    svgStartY () {
      return - this.width/2 - this.paddingTop
    },

    svgWidth () {
      return this.width + this.paddingSides*2
    },

    svgHeight () {
      return this.width + this.paddingTop + this.paddingBottom
    },

    arcRadius () {
      return this.circleRadius + this.arcWidth
    },

    dialSize () {
      return this.arcWidth + DIAL_ARC_OVERLAP - this.dialArcGap
    },

    arcSectionLengthPercentage () {
      return (100 - (this.data.max - 1) * this.arcSectionDividerPercent) / this.data.max
    },

    dialValuePercentage () {
      return (this.data.value - 1/2) * this.arcSectionLengthPercentage +
        (this.data.value -1) * this.arcSectionDividerPercent
    },

    arrowPoints () {
      const
        radius =  this.circleRadius - DIAL_ARC_OVERLAP,
        outerEndX = this.getCoordFromPercentage(this.dialValuePercentage, 'x', radius),
        outerEndY = this.getCoordFromPercentage(this.dialValuePercentage, 'y', radius),
        arrowPoints = `0,0 ${outerEndX},${outerEndY}`

      return arrowPoints
    },
  },

  methods: {
    getArcSectionPath (arcNumber) {
      const startPercentage = this.getArcStartPercentage(arcNumber)
      const endPercentage = this.getArcEndPercentage(arcNumber)

      const 
        outerStartX = this.getCoordFromPercentage(startPercentage, 'x', this.arcRadius),
        outerStartY = this.getCoordFromPercentage(startPercentage, 'y', this.arcRadius),
        outerEndX = this.getCoordFromPercentage(endPercentage, 'x', this.arcRadius),
        outerEndY = this.getCoordFromPercentage(endPercentage, 'y', this.arcRadius)

      return `M ${outerStartX} ${outerStartY} 
        A ${this.arcRadius} ${this.arcRadius} 0 0 0 ${outerEndX} ${outerEndY} 
        L 0 0
        Z`
    },

    getArcStartPercentage (n) {
      return (n - 1) * (this.arcSectionLengthPercentage + this.arcSectionDividerPercent)
    },

    getArcEndPercentage (n) {
      return this.getArcStartPercentage(n) + this.arcSectionLengthPercentage
    },

    getCoordFromPercentage (percentage, coord, radius) {
      const trig = coord === 'x' ? 'cos' : 'sin'
      const percentageCappedAt100 = Math.min(percentage, 100)
      const degreesFromDialStart = (percentageCappedAt100 / 100) * this.dialRangeInDegrees
      const degreesToDialStart = 90 + this.dialRangeInDegrees / 2
      const radiansToCoord = (degreesToDialStart - degreesFromDialStart) * 2 * Math.PI / 360

      return radius * Math[trig](radiansToCoord)
    }
  }
}
</script>