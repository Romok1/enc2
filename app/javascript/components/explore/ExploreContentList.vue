<template>
  <ul 
    v-show="isCategoryActive"
    :id="id"
    class="ul--unstyled"
  >
    <li
      v-for="item in filteredItems"
      :key="item.id"
      class="no-margin"
    >
      <expandable-item>
        <template slot="header">
          <div class="explore-panel__left explore-panel__header flex flex-v-center">
            <h4 class="explore-panel__header-title h3">
              {{ item.name }}
            </h4>
          </div>

          <template v-if="showAssetsInHeader">
            <div class="explore-panel__header-assets explore-panel__right flex flex-v-center">
              <span class="explore-panel__assets-label paragraph--no-margin">{{ assetsLabel }}:</span>
              <span
                v-for="asset in getUniqueAssets(item)"
                :key="asset.id"
                :class="getAssetIconClass(asset.name)"
                :title="asset.name"
              />
            </div>
          </template>
        </template>

        <template slot="content">
          <div class="explore-panel__dropdown-body">
            <div class="explore-panel__content flex flex-h-start">
              <div class="explore-panel__left">
                <p>{{ item.description }}</p>
              </div>

              <div class="explore-panel__right flex flex-h-between flex-v-start">
                <ul
                  v-if="showAssets"
                  class="explore-content-list__assets"
                >
                  <li
                    v-for="asset in getUniqueAssets(item)"
                    :key="asset.id"
                  >
                    <a
                      class="explore-content-list__asset h3 flex flex-v-center"
                      :class="getAssetIconClass(asset.name)"
                      :href="$url(getAssetPath(asset.id))"
                    >
                      {{ asset.name }}
                    </a>
                  </li>
                </ul>
              </div>
              <div class="explore-content-list__buttons flex flex-v-start flex-no-shrink">
                <a
                  class="explore-content-list__button button--arrow-w button--green-dark button--medium button--shadow-light"
                  :href="$url(getFactsheetPath(item.id))"
                >
                  {{ buttons_t.factsheet }}
                </a>
                <a
                  v-if="getMapPath"
                  class="explore-content-list__button button--arrow button--green button--medium button--shadow-light"
                  :href="$url(getMapPath(item.id))"
                  target="_blank"
                >
                  {{ buttons_t.explore_map }}
                </a>
              </div>
            </div>
            <production-processes
              v-if="isCategoryActive"
              :service-or-impact-driver-id="item.id"
              :joins="getFilteredJoins(item)"
            />
          </div>
        </template>
      </expandable-item>
    </li>
  </ul>
</template>

<script>
import { getAssetIconClass } from '~/helpers/application-helpers'
import { IMPACTS_ID, MATERIALITIES_ID } from '~/helpers/explore-helpers'
import { getAssetPath, getEcosystemServicePath, getMapURLByServiceId } from '~/helpers/request-helpers'
import { mixinExplore } from '~/components/explore/mixins/mixin-explore'


import ExpandableItem from '~/common/ExpandableItem'
import ProductionProcesses from '~/components/ProductionProcesses'

export default {
  components: {
    ExpandableItem,
    ProductionProcesses,
  },

  mixins: [mixinExplore],

  props: {
    id: {
      type: String,
      default: ''
    },

    items: {
      type: Array,
      default: () => []
    },

    showAssets: {
      type: Boolean,
      default: true
    },

    isCategoryActive: {
      type: Boolean,
      default: false
    },

    getMapPath: {
      default: null,
      type: Function
    },

    getFactsheetPath: {
      type: Function,
      required: true
    },

    joinModel: {
      type: String,
      default: MATERIALITIES_ID
    }
  },

  computed: {
    assetsLabel () {
      return this.joinModel === IMPACTS_ID ? '' : this.tool_t.provided_by
    },

    buttons_t () {
      return this.$t('buttons')
    },

    tool_t () {
      return this.$t('explore.tool')
    },

    showAssetsInHeader () {
      return this.showAssets && this.joinModel !== IMPACTS_ID
    },

    isEmpty () {
      return !this.filteredItems.length > 0
    },

    filteredItems () {
      return this.items.filter(item => {
        return this.getFilteredJoins(item).length > 0
      })
    }
  },

  watch: {
    filteredItems () {
      this.updateItemCount()
    }
  },

  mounted () {
    this.updateItemCount()
  },

  methods: {
    getAssetIconClass (assetName) {
      return getAssetIconClass(assetName)
    },

    getAssetPath (id) {
      return getAssetPath (id)
    },

    getEcosystemServicePath (id) {
      return getEcosystemServicePath(id)
    },

    getMapURLByServiceId (id) {
      return getMapURLByServiceId(id)
    },

    getUniqueAssets (item) {
      return item.unique_assets ? item.unique_assets : item.assets
    },

    updateItemCount() {
      this.$emit('update:item-count', this.filteredItems.length)
    }
  }
}
</script>