<template>
  <pane
    :title="headerText.title"
  >
    <div class="dashboard-stats">
      <div class="dashboard-stats__columns">
        <div
          v-for="tile in tiles"
          :key="tile.title"
          class="dashboard-stats__column"
        >
          <div class="dashboard-stats__tile">
            <div class="dashboard-stats__circle">
              <div class="dashboard-stats__count">
                {{ tile.items.length }}
              </div>

              <div class="dashboard-stats__count-text">
                {{ getCountText(tile.total) }}
              </div>
            </div>

            <div class="dashboard-stats__content">
              <h3 class="dashboard-stats__subtitle">
                {{ tile.title }}
              </h3>

              <p
                class="dashboard-stats__text"
                v-html="tile.text"
              />

              <button
                class="dashboard-stats__link"
                @click="onClick(tile)"
              >
                {{ $t('buttons.more_info') }}
                <span class="dashboard-stats__link-icon" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </pane>
</template>

<script>
import Pane from '~/components/dashboard/Pane'

export default {
  components: { Pane },

  props: {
    tiles: {
      type: Array,
      default: () => []
    },
    headerText: {
      type: Object,
      required: true
    }
  },

  methods: {
    getCountText (total) {
      return this.$t('natural_capital.dashboard.components.dashboard_stats.out_of')
        .replace('%{n}', total).toLowerCase()
    },

    onClick (tile) {
      this.$root.$emit('natural-capital-modal:open', {
        name: tile.title,
        text: tile.text,
        dataType: 'eco_servs_or_impact_drivers',
        items: tile.items,
        category: tile.category
      })
    }
  }
}
</script>
