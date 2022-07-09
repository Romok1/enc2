<template>
  <div class="ecosystem">
    <div
      v-for="category in filteredCategories"
      :key="category.id"
      class="explore-content-category"
      :class="{'explore-content-category--active': isCategoryActive(category.id)}"
    >
      <div class="explore-content-category__header flex flex-v-center">
        <h3 class="explore-content-category__header-text">
          {{ category.name }}
        </h3>
        <tooltip :text="getCategoryDescription(category)" />
        <span class="explore-content-category__count h4">({{ getServiceCountForCategory(category) }})</span>
        <button
          aria-haspopup="true"
          :aria-expanded="isCategoryActive(category.id)"
          :aria-controls="getCategoryElementId(category)"
          class="explore-content-category__show-button button--medium button--border icon-plus"
          @click="toggleCategory(category.id)"
        >
          <div class="explore-content-category__button-message">
            {{ getButtonMessage(category.id) }}
          </div>
        </button>
      </div>

      <explore-content-list
        :id="getCategoryElementId(category)"
        :is-category-active="isCategoryActive(category.id)"
        :items="category.services"
        :show-assets="showAssets"
        :get-map-path="getMapPath" 
        :get-factsheet-path="getFactsheetPath"
        :join-model="materialitiesId"
      />
    </div>
  </div>
</template>

<script>
import { getServicesCountFromCategories, DEPENDENCIES_SERVICES_ID, MATERIALITIES_ID } from '~/helpers/explore-helpers'
import { getMapURLByServiceId, getEcosystemServicePath } from '~/helpers/request-helpers'
import { mixinExplore } from '~/components/explore/mixins/mixin-explore'
import ExploreContentList from './ExploreContentList'
import Tooltip from '~/components/tooltip/Tooltip'

export default {
  components: {
    ExploreContentList,
    Tooltip
  },

  mixins: [mixinExplore],

  props: {
    showAssets: {
      default: true,
      type: Boolean
    },
    isInServicesTab: {
      default: true,
      type: Boolean
    },
    id: {
      default: 0,
      type: Number
    },

    categories: {
      default: null,
      type: Array
    }
  },

  data() {
    return {
      activeCategory: null,
      buttons_t: this.$t('buttons'),
      common_t: this.$t('common'),
      getMapPath: getMapURLByServiceId,
      getFactsheetPath: getEcosystemServicePath,
      materialitiesId: MATERIALITIES_ID
    }
  },

  computed: {
    categoriesPropOrDefault () {
      return this.categories ? this.categories : this.$store.state.explore.categories
    },

    filteredCategories () {
      const filteredCategories = this.categoriesPropOrDefault.map(category => {
        const newCategory = {...category}

        newCategory.services = newCategory.services.filter(service => this.isServiceVisible(service))

        return newCategory
      })

      return filteredCategories.filter(category => category.services.length)
    },

    isEmpty () {
      return !this.filteredCategories.length
    }
  },

  watch: {
    filteredCategories () {
      this.updateExploreContentCountIfNecessary()
    }
  },

  mounted () {
    this.updateExploreContentCountIfNecessary()
  },

  methods: {
    toggleCategory(id) {
      this.activeCategory = (this.activeCategory === id) ? null : id
    },

    getCategoryElementId(category) {
      return `explore-content-category-${category.id}-${this._uid}`
    },

    isCategoryActive(id) {
      return this.activeCategory === id
    },

    isServiceVisible(service) {
      return this.getFilteredJoins(service).length
    },

    getButtonMessage(id) {
      return id === this.activeCategory ? this.buttons_t.hide_all : this.buttons_t.show_all
    },

    getServiceCountForCategory(category) {
      return category.services.length
    },

    getCategoryDescription(category) {
      return category.services[0].category_description
    },

    updateExploreContentCountIfNecessary() {
      if (this.isInServicesTab) {
        this.$store.commit(
          'explore/updateExploreContentCounts',
          {
            vm: this,
            id: DEPENDENCIES_SERVICES_ID,
            count: getServicesCountFromCategories(this.filteredCategories)
          }
        )
      }
    }
  }
}
</script>
