export default {
  methods: {
    getHeaderTooltip (headerId) {
      return this.$t('biodiversity_goals.dashboard.shared.tooltips')[headerId] || null
    },

    getTextAlignForHeader (headerId) {
      if (['star', 'ecoIntegrityRisk'].indexOf(headerId) >= 0) {
        return 'right'
      } 

      return 'left'
    }
  }
}