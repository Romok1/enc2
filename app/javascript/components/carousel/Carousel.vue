<template>
  <flickity
    ref="flickity"
    :key="keyIncrementer"
    class="carousel"
    :class="{ 'carousel--active': active }"
    :options="computedOptions"
  >
    <slot />
  </flickity>
</template>

<script>
import { debounce } from 'lodash'
import eventHandler from '~/mixins/mixin-element-event-handler'
import Flickity from 'vue-flickity'

const DEFAULT_OPTIONS = {
  autoPlay: 5000,
  cellAlign: 'left',
  pageDots: true,
  prevNextButtons: false,
  watchCSS: true,
  wrapAround: true,
}

export default {
  components: {
    Flickity
  },

  mixins: [
    eventHandler(window, 'resize', debounce(function () {
      this.refresh()
    }, 100))
  ],

  props: {
    active: {
      type: Boolean,
      default: true
    },
    options: {
      type: Object,
      required: false,
      default: () => ({})
    }
  },

  data () {
    return {
      keyIncrementer: 0
    }
  },

  computed: {
    computedOptions () {
      return Object.assign(DEFAULT_OPTIONS, this.options)
    },
  },

  created () {
    this.$root.$on('refresh-carousel', this.refresh)
  },

  mounted () {
    this.refresh()
  },

  methods: {
    refresh () {
      this.$nextTick(() => {
        this.keyIncrementer++
      })
    }
  }
}
</script>
