<template>
  <div class="portfolio-generator">
    <tabs
      modifier="portfolio-generator"
      @tab-changed="onTabChanged"
    >
      <tab
        id="manual"
        title="Manually Enter Data"
        :active="selectedTab === 'manual'"
      >
        <component :is="`builder-${selectedSector}`" />
      </tab>
      <tab
        id="upload"
        title="Upload Portfolio CSV"
        :active="selectedTab === 'upload'"
      >
        <uploader
          v-bind="{
            endpoint: csvUploadEndpoint,
            redirect: csvUploadRedirectEndpoint 
          }"
        />
      </tab>
    </tabs>
  </div>
</template>

<script>
import BuilderAgriculture from './agriculture/Builder'
import BuilderMining from './mining/Builder'
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'
import Uploader from '~/components/dashboard/biodiversity-goals/portfolio-generators/Uploader'

export default {
  components: {
    BuilderAgriculture,
    BuilderMining,
    Tab,
    Tabs,
    Uploader
  },

  props: {
    selectedSector: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      selectedTab: this.$store.state.biodiversityGoals.portfolioGenerator.selectedTab
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.portfolio.forms.agriculture')
    },

    csvUploadEndpoint () {
      if (this.selectedSector === 'agriculture') {
        return `/${this.$i18n.locale}/tools/biodiversity-goals/agriculture-dashboard/upload-csv`
      }

      // else selectedSector is 'mining'
      return `/${this.$i18n.locale}/tools/biodiversity-goals/mining-dashboard/upload-csv`
    },

    csvUploadRedirectEndpoint () {
      if (this.selectedSector === 'agriculture') {
        return `/${this.$i18n.locale}/tools/biodiversity-goals/agriculture-dashboard`
      }

      // else selectedSector is 'mining'
      return `/${this.$i18n.locale}/tools/biodiversity-goals/mining-dashboard`
    },
  },

  methods: {
    onTabChanged (tabId) {
      this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateSelectedTab', tabId)
    }
  }
}
</script>
