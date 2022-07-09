export default {
  props: {
    forPdf: {
      type: Boolean,
      default: false
    },

    preloadData: {
      type: Object,
      default: () => ({})
    },

    module: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      busy: false,
      data: undefined,
      showGenerator: false,
      showDetails: false
    }
  },
  
  computed: {
    forms: {
      set (forms) {
        this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateForms', forms)
      },
      get () {
        return this.$store.state.biodiversityGoals.portfolioGenerator.forms
      }
    },

    isDirty () {
      return this.preloadData ? this.preloadData.isDirty : false
    },

    loadedPortfolio () {
      return this.preloadData ? this.preloadData.portfolio : undefined
    }
  },

  watch: {
    showGenerator (show) {
      if (show) {
        this.setOriginalForms()
      }
    }
  },
  
  beforeMount () {
    if (this.preloadData) {
      this.updateDashboardData(this.preloadData)
    }

    this.$root.$on('edit-dashboard', this.onEditDashboard)
    this.$root.$on('show-dashboard-details-modal', this.showDetailsModal)
  },

  beforeDestroy() {
    this.$root.$off('edit-dashboard', this.onEditDashboard)
    this.$root.$off('show-dashboard-details-modal', this.showDetailsModal)
  },

  methods: {
    onEditDashboard () {
      this.showGeneratorModal(true)
    },
    
    updateDashboardData (data) {
      const { dashboard, forms } = data

      this.data = dashboard
      this.forms = [...forms]
    },
    
    setOriginalForms () {
      this.forms = [...this.preloadData.forms]
    },
    
    showGeneratorModal (show) {
      this.showGenerator = show === true
    },

    showDetailsModal (show) {
      this.showDetails = show === true
    }
  }
}