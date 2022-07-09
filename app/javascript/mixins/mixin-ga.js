export default {
  methods: {
    trackIBATLink (label=null, mouseButton='left') {
      // 1 is definite link and 0 is intent to link
      const intent = mouseButton === 'left' ? 1 : 0

      if (this.$ga) {
        this.$ga.event({
          eventCategory: 'IBAT',
          eventAction: 'Link',
          eventLabel: label,
          eventValue: intent
        })
      }
    }
  }
}