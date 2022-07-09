<template>
  <div
    :class="selectedSectorClass"
    class="portfolio-generator-modal portfolio-generator-modal--biodiversity-goals"
  >
    <ModalFull v-model="show">
      <template v-slot:topleft>
        <button
          v-if="isSectorSelected"
          class="modal-full__button"
          @click="clearSector"
        >
          <icon-back />
        </button>
      </template>

      <template v-slot:body>
        <div v-if="isSectorSelected">
          <PortfolioGenerator
            v-model="forms"
            v-bind="{ selectedSector }"
          />
        </div>

        <SectorSelect
          v-else
          v-model="selectedSector"
          v-bind="{ sectors }"
        />
      </template>

      <template v-slot:footer>
        <PortalTarget name="portfolio-generator-modal-footer" />
      </template>
    </ModalFull>

    <button
      v-if="hasToggle"
      class="portfolio-generator-modal__toggle"
      @click="showModal"
    >
      {{ t.toggle_text }}
    </button>
  </div>
</template>

<script>
import PortfolioGenerator from './Generator'
import IconBack from '~/icons/IconBack'
import ModalFull from '~/components/modal/ModalFull'
import SectorSelect from './SectorSelect'

export default {
  components: {
    PortfolioGenerator,
    IconBack,
    ModalFull,
    SectorSelect
  },

  props: {
    sectors: {
      type: Array,
      required: true
    },

    hasToggle: {
      type: Boolean,
      default: true
    }
  },

  data () {
    return {
      show: false
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

    selectedSector: {
      set (selectedSector) {
        this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateSelectedSector', selectedSector)
      },
      get () {
        return this.$store.state.biodiversityGoals.portfolioGenerator.selectedSector
      }
    },

    isSectorSelected () {
      return this.selectedSector !== undefined
    },

    selectedSectorClass () {
      return { 'portfolio-generator-modal--sector-selected': this.isSectorSelected }
    },

    t () {
      return this.$t('biodiversity_goals.landing.modal')
    }
  },

  created () {
    this.$root.$on('portfolio-generator-modal:open', this.showModal)
  },

  beforeDestroy () {
    this.$root.$off('portfolio-generator-modal:open', this.showModal)
  },

  methods: {
    clearSector () {
      this.selectedSector = undefined
    },

    showModal () {
      this.show = true
    }
  }
}
</script>
