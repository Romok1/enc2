<template>
  <div class="assets">
    <h2 class="screen-reader">
      {{ common_t.assets }}
    </h2>
    <template v-for="asset in filteredAssets">
      <expandable-item
        v-show="isAssetShown(asset)"
        :key="asset.id"
      >
        <template slot="header">
          <div class="explore-panel__left">
            <h3 class="explore-panel__header-title flex flex-v-center">
              <span :class="getAssetIconClass(asset.name)" />
              {{ asset.name }}
            </h3>
          </div>
        </template>

        <template slot="content">
          <div class="asset__panel-content flex flex-h-start">
            <div class="explore-panel__left">
              <p>{{ asset.description }}</p>
            </div>

            <div class="asset__buttons">
              <a
                class="asset__button button--grey button--arrow-w button--medium button--shadow-light flex-hs-end"
                :href="`/${$i18n.locale}${getAssetPath(asset.id)}`"
              >
                {{ buttons_t.more_details }}
              </a>
            </div>
          </div>

          <explore-content-service-list
            v-if="hasNestedEcoServices"
            :id="asset.id"
            :is-in-services-tab="false"
            :categories="asset.categories"
            :show-assets="false"
          />

          <explore-content-list
            v-else
            :id="asset.id.toString()"
            :items="asset.impactDrivers" 
            :is-category-active="isAssetShown(asset)"
            :get-factsheet-path="getImpactDriverFactsheetPath"
            :get-map-path="getImpactsMapPath"
            :show-assets="false"
            :join-model="joinModel"
          />
        </template>
      </expandable-item>
    </template>
  </div>
</template>

<script>
import { getAssetIconClass } from '~/helpers/application-helpers'
import { getCategories, getAssetCountFromVisibilitiesById,  MATERIALITIES_ID, IMPACTS_ID } 
  from '~/helpers/explore-helpers'
import { getAssetPath, getImpactDriverPath, getImpactsMapURl } from '~/helpers/request-helpers'

import ExpandableItem from '~/common/ExpandableItem'
import ExploreContentList from './ExploreContentList'
import ExploreContentServiceList from './ExploreContentServiceList'

export default {
  components: {
    ExpandableItem,
    ExploreContentList,
    ExploreContentServiceList
  },

  props: {
    nestedModel: {
      type: String,
      required: true
    },
    parentTabId: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      children: [],
      buttons_t: this.$t('buttons'),
      common_t: this.$t('common'),
      getImpactDriverFactsheetPath: getImpactDriverPath,
      getImpactsMapPath: getImpactsMapURl
    }
  },

  computed: {
    assets () {
      const assets = this.$store.state.explore.assets[this.nestedModel]

      return assets ? assets : []
    },

    hasNestedEcoServices () {
      return this.nestedModel === 'es'
    },

    joinModel () {
      return this.hasNestedEcoServices ? MATERIALITIES_ID : IMPACTS_ID
    },

    exploreContentServiceLists () {
      const expandableItems = this.children.filter(child =>
        child.$options._componentTag === 'expandable-item'
      )

      return expandableItems.map(item =>
        item.$children.filter(child => 
          child.$options._componentTag === 'explore-content-service-list' ||
          child.$options._componentTag === 'explore-content-list'
        )[0]
      )
    },

    filteredAssets () {
      const assets = this.assets.map(asset => {
        const assetWithNestedModels = {
          id: asset.id,
          name: asset.name,
          description: asset.description,
        }

        if (this.hasNestedEcoServices) {
          assetWithNestedModels.categories = this.serviceCategoriesForAsset(asset)
        } else {
          assetWithNestedModels.impactDrivers = asset.impact_drivers
        }

        return assetWithNestedModels
      })

      if (this.hasNestedEcoServices) {
        return assets.filter(asset => asset.categories.length)
      }

      return assets.filter(asset => asset.impactDrivers.length)
    },

    serviceListVisbilitiesById () {
      const listVisbilitiesById = {}

      if (this.exploreContentServiceLists.length) {
        this.exploreContentServiceLists.forEach(list => {
          listVisbilitiesById[list.$props.id] = !list.isEmpty
        })
      }

      return listVisbilitiesById
    }
  },

  watch: {
    serviceListVisbilitiesById () {
      this.updateAssetCount()
    }
  },

  mounted() {
    this.children = this.$children
    this.updateAssetCount()
  },

  methods: {
    getExpandableItemId (asset) {
      return `explore-content-assets-${asset.id}`
    },

    getAssetIconClass(assetName) {
      return getAssetIconClass(assetName)
    },

    getAssetPath(id) {
      return getAssetPath(id)
    },

    serviceCategoriesForAsset(asset) {
      return getCategories(asset.ecosystem_services)
    },

    isAssetShown (asset) {
      return this.serviceListVisbilitiesById[asset.id]
    },

    updateAssetCount () {
      this.$store.commit(
        'explore/updateExploreContentCounts',
        {
          vm: this,
          id: this.parentTabId,
          count: getAssetCountFromVisibilitiesById(this.serviceListVisbilitiesById)
        }
      )
    }
  }
}
</script>
