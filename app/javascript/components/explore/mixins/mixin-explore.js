import { UNDEFINED_ID } from '~/helpers/explore-helpers'

export const mixinExplore = {
  computed: {
    filterSelections () {
      return this.$store.state.explore.selections
    },

    sectors () {
      return this.$store.state.explore.sectors
    },

    subIndustries () {
      return this.$store.state.explore.subIndustries
    }
  },

  methods: {
    getFilteredJoins(item) {    
      return this.getJoins(item).filter(this.isSelectedProductionProcess)
    },

    getJoins(item) {
      return item.sorted_materialities ? item.sorted_materialities : item.sorted_impacts
    },

    getProductionProcessesForSelectedSubIndustry () {
      const selectedSubIndustry =
        this.subIndustries.find(
          sub_industry => {
            return this.filterSelections.sub_industry == sub_industry.id
          }
        )

      return selectedSubIndustry ? selectedSubIndustry.production_processes : []
    },

    getSubIndustriesForSelectedSector () {
      const selectedSector =
        this.sectors.find(
          sector => this.filterSelections.sector == sector.id
        )

      return selectedSector ? [...selectedSector.sub_industries] : []
    },

    isSelectedProductionProcess (process) {
      const processID = process.production_process.id

      if (this.filterSelections.production_process.length) {
        return this.filterSelections.production_process.indexOf(processID) >= 0
      } else if (this.filterSelections.sub_industry !== UNDEFINED_ID) {
        const productionProcessIDs = this.getProductionProcessesForSelectedSubIndustry().map(pp => pp.id)

        return productionProcessIDs.indexOf(processID) >= 0
      } else if (this.filterSelections.sector !== UNDEFINED_ID) {
        let selected = false

        this.getSubIndustriesForSelectedSector().forEach(sub_industry => {
          if (selected) { return }

          const productionProcessIDs = sub_industry.production_processes.map(pp => pp.id)

          if (productionProcessIDs.indexOf(processID) >= 0) { selected = true }
        })


        return selected
      }

      return true
    },
  }
}
