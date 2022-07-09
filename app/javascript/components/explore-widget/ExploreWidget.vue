<template>
  <aside class="explore-widget flex flex-column">
    <p class="explore-widget__text">
      {{ widget_t.description }}
    </p>
    <tabs
      :show-help-icon="true"
      modifier="home"
      @tab-changed="handleTabChange"
    >
      <tab
        v-for="(filter) in filters"
        :id="filter.id"
        :key="filter.id"
        :title="filter.name"
        :tooltip="tooltips_t[filter.id]"
      >
        <v-radio-group
          :group-name="filter.id"
          :options="radioOptions"
          :selected="selectedTab"
          @update:selected="updateSelectedTab"
        />
        <div class="explore-widget__inputgroup">
          <v-select-searchable
            class="explore-widget__dropdown"
            :config="filter"
            :options="getOptions(filter)"
            :placeholder="placeholderText(filter)"
            :selected="getSelectedOptionIdForTab(filter)"
            @update:selected-option="updateSelectedOptions(filter, $event)"
          />
          <a
            class="explore-widget__button"
            :href="$url(exploreUrl)"
          >
            {{ buttons_t.explore }}
          </a>
        </div>
      </tab>
    </tabs>
  </aside>
</template>

<script>
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'
import { DEPENDENCIES_ID, IMPACTS_ID, UNDEFINED_ID } from '~/helpers/explore-helpers'
import VRadioGroup from '~/components/v-radio-group/VRadioGroup'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: {
    Tab,
    Tabs,
    VRadioGroup,
    VSelectSearchable
  },

  data () {
    return {
      common_t: this.$t('common'),
      tooltips_t: this.$t('tooltips'),
      widget_t: this.$t('explore.widget'),
      radios_t: this.$t('explore.widget.radios'),
      buttons_t: this.$t('buttons'),
      undefinedObject: {id: UNDEFINED_ID, name: this.$t('common.none')},
      selected: null,
      selectedTab: DEPENDENCIES_ID
    }
  },

  computed: {
    selections() {
      return this.$store.state.explore.selections
    },

    radioOptions() {
      return [
        { id: DEPENDENCIES_ID, name: this.radios_t.dependencies.name, value: DEPENDENCIES_ID },
        { id: IMPACTS_ID, name: this.radios_t.impacts.name, value: IMPACTS_ID }
      ]
    },

    filters() {
      return [
        { id: 'sector', name: this.common_t.sector, hasSearch: true, showSearchIcons: true },
        { id: 'sub_industry', name: this.common_t.sub_industry, hasSearch: true, showSearchIcons: true }
      ]
    },

    exploreUrl () {
      return `/explore?tab=${this.selectedTab}`
    }
  },

  created() {
    this.$store.commit('explore/resetSelections', { vm: this })
    this.$store.commit('explore/initializeSectors', { vm: this })
  },

  methods: {
    getOptions (filter) {
      if (filter.id === 'sector') {
        return this.$store.state.explore.sectors
      } else if (filter.id === 'sub_industry') {
        return this.$store.state.explore.subIndustries
      }
    },

    placeholderText (filter) {
      if (filter.id === 'sector') {
        return `- ${this.buttons_t.sector_placeholder} -`
      } else if (filter.id === 'sub_industry') {
        return `- ${this.buttons_t.sub_industry_placeholder} -`
      }
    },

    getSelectedOptionIdForTab (filter) {
      const selectedOption = this.selections[filter.id]

      return selectedOption ? selectedOption : null
    },

    handleTabChange () {
      this.filters.forEach(filter => {
        this.updateSelectedOptions(filter, UNDEFINED_ID)
      })
    },

    updateSelectedOptions (filter, newSelection) {
      this.$store.commit('explore/updateSelections', {
        vm: this,
        id: filter.id,
        newSelection
      })
    },

    updateSelectedTab (newTab) {
      this.selectedTab = newTab
    }
  }
}
</script>
