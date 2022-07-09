<template>
  <pane
    :title="t.title"
  >
    <div class="main-assets">
      <div class="main-assets__header">
        <p class="main-assets__text">
          {{ t.text }}
        </p>

        <div class="main-assets__legend">
          <div
            v-for="entity in entities"
            :key="`main-assets-legend-item-${entity.id}`"
            :class="getLegendItemClasses(entity)"
          >
            {{ entity.name }}
          </div>
        </div>
      </div>

      <ul class="main-assets__rows">
        <li
          v-for="asset in data.assets"
          :key="`main-assets-asset-${asset.id}`"
          class="main-assets__row"
        >
          <div class="main-assets__asset">
            <div class="main-assets__asset-name">
              <span :class="getAssetIconClass(asset)" />
              {{ asset.name }}
              <a
                class="main-assets__asset-name-link"
                :href="getAssetPath(asset)"
              />
            </div>

            <bars
              class="main-assets__bars"
              :bars="getBars(asset)"
            />

            <a
              class="main-assets__link"
              :href="getAssetPath(asset)"
              target="_blank"
            >
              <span class="main-assets__link-text">
                {{ $t('buttons.view') }}
              </span>

              <span class="main-assets__link-icon" />
            </a>
          </div>
        </li>
      </ul>
    </div>
  </pane>
</template>

<script>
import { getAssetPath } from '~/helpers/request-helpers'
import { getAssetIconClass } from '~/helpers/application-helpers'
import Bars from './Bars'
import Pane from '~/components/dashboard/Pane'

export default {
  components: {
    Bars,
    Pane
  },

  props: {
    data: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      entities: [
        {
          id: 'ecosystemService',
          className: 'ecosystem_services',
          name: this.$t('common.dependencies'),
          name_s: this.$t('common.e_service_s')
        },
        {
          id: 'impactDriver',
          className: 'impact_drivers',
          name: this.$t('common.impacts'),
          name_s: this.$t('common.impact_driver_s')
        }
      ]
    }
  },

  computed: {
    t () {
      return this.$t('natural_capital.dashboard.components.main_assets')
    }
  },

  methods: {
    getAssetIconClass (asset) {
      return `main-assets__asset-icon ${getAssetIconClass(asset.name)}`
    },

    getAssetPath (asset) {
      return this.$url(getAssetPath(asset.id))
    },

    getBars (a) {
      return this.entities.map(e => ({
        id: e.id,
        label: e.name_s,
        value: a[`${e.id}Count`],
        classModifier: e.className,
        maxValue: this.data[`${e.id}Total`]
      }))
    },

    getLegendItemClasses (entity) {
      return [
        'main-assets__legend-item',
        `main-assets__legend-item--${entity.className}`
      ]
    }
  }
}
</script>
