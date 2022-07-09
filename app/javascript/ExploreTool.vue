<template>
  <main class="explore-tool">
    <explore-filters class="flex flex-v-center" />
    <span class="explore-tool__count-wrapper">
      <span
        v-show="!isSmall()"
        class="explore-tool__count h3"
      >{{ tabContentCountMessage }}</span>
    </span>

    <tabs
      modifier="explore"
      :show-help-icon="true"
      :init-active-id="selectedTab"
      @tab-changed="updateActiveTab"
    >
      <tab
        :id="dependenciesId"
        :title="common_t.dependencies"
        :tooltip="tooltips_t.dependencies"
        :active="true"
      >
        <explore-dependencies-tabs @select-tab="updateActiveDependenciesTab" />
      </tab>

      <tab
        :id="impactsId"
        :title="common_t.impacts"
        :tooltip="tooltips_t.impacts"
      >
        <explore-impacts-tabs @select-tab="updateActiveImpactsTab" />
      </tab>
    </tabs>
  </main>
</template>

<script>
import Tabs from '~/components/tabs/Tabs'
import Tab from '~/components/tabs/Tab'
import ExploreDependenciesTabs from '~/components/explore/ExploreDependenciesTabs'
import ExploreImpactsTabs from '~/components/explore/ExploreImpactsTabs'
import ExploreFilters from '~/components/explore/ExploreFilters'
import { mixinResponsive } from '~/mixins/mixin-responsive'
import { DEPENDENCIES_ID, DEPENDENCIES_SERVICES_ID, IMPACTS_IMPACT_DRIVERS_ID, IMPACTS_ID } from '~/helpers/explore-helpers'

export default {
  components: {
    Tabs,
    Tab,
    ExploreDependenciesTabs,
    ExploreFilters,
    ExploreImpactsTabs
  },

  mixins: [mixinResponsive],

  props: {
    selectedTab: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      dependenciesId: DEPENDENCIES_ID,
      impactsId: IMPACTS_ID,
      activeTabId: DEPENDENCIES_ID,
      activeDependenciesTabId: DEPENDENCIES_SERVICES_ID,
      activeImpactsTabId: IMPACTS_IMPACT_DRIVERS_ID,
    }
  },

  computed: {
    buttons_t () {
      return this.$t('buttons')
    },

    common_t () {
      return this.$t('common')
    },

    tooltips_t () {
      return this.$t('tooltips')
    },

    exploreContentCounts () {
      return this.$store.state.explore.exploreContentCounts
    },

    activeSubTabId () {
      return this.activeTabId === DEPENDENCIES_ID ?
        this.activeDependenciesTabId : this.activeImpactsTabId
    },

    tabContentCountMessage () {
      const showingMessage = this.isLarge() ? `${this.buttons_t.showing} - ` : ''
      const count = this.exploreContentCounts[this.activeSubTabId] || 0

      return showingMessage + count
    },
  },

  created () {
    this.$store.commit('explore/initializeAssets', { vm: this, includeType: 'es' })
    this.$store.commit('explore/initializeAssets', { vm: this, includeType: 'id' })
    this.$store.commit('explore/initializeCategories', { vm: this })
    this.initActiveTabs()
  },

  methods: {
    initActiveTabs () {
      if (this.selectedTab) {
        this.updateActiveTab(this.selectedTab)
      }
    },

    updateActiveTab (id) {
      this.activeTabId = id
    },

    updateActiveDependenciesTab (id) {
      this.activeDependenciesTabId = id
    },

    updateActiveImpactsTab (id) {
      this.activeImpactsTabId = id
    }
  }
}
</script>
