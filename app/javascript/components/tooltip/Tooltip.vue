<template>
  <div class="tooltip">
    <div
      v-touch="toggleTooltip"
      tabindex="0"
      :aria-describedby="id"
      :aria-expanded="isActive"
      class="tooltip__trigger"
      @mouseenter="toggleTooltip(true)"
      @mouseleave="toggleTooltip(false)"
    >
      <span class="question-mark" />
    </div>
    <div
      v-show="isActive"
      :id="id"
      role="tooltip"
      class="tooltip__target"
    >
      {{ text }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'Tooltip',

  props: {
    text: {
      default: () => '',
      type: String
    }
  },

  data () {
    return {
      isActive: false,
      id: this._uid
    }
  },

  mounted () {
    const tooltipTrigger = this.$el.querySelector('.tooltip__trigger')

    tooltipTrigger.addEventListener('blur', () => {
      this.toggleTooltip(false)
    })
    tooltipTrigger.addEventListener('focus', () => {
      this.toggleTooltip(true)
    })
  },

  methods: {
    toggleTooltip (boolean) {
      this.isActive = typeof boolean == 'boolean' ? boolean : !this.isActive
    }
  }
}
</script>
