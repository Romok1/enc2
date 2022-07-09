<template>
  <dashboard-modal
    v-if="data"
    v-model="active"
    :class="`dashboard-modal--${data.dataType}`"
  >
    <template slot="header">
      <h3 class="dashboard-modal__title">
        {{ data.name }}
      </h3>

      <p
        v-if="data.text"
        class="dashboard-modal__description"
        v-html="data.text"
      />
    </template>
 
    <template slot="body">
      <ul class="dashboard-modal__list-items">
        <li
          v-for="item in data.items"
          :key="item.id"
          class="dashboard-modal__list-item"
        >
          <p class="dashboard-modal__text">
            {{ item.name }}
          </p>
          <span
            v-if="data.dataType === 'production_processes'"
            class="dashboard-modal__process-rating"
            :class="ratingClass"
          />
          <a
            v-if="data.dataType === 'eco_servs_or_impact_drivers'"
            :href="getServiceUrl(data.category, item.id)"
            target="_blank"
            class="dashboard-modal__button"
          >
            {{ $t('buttons.explore_map') }}
          </a>
        </li>
      </ul>
    </template>

    <template
      v-if="data.href"
      slot="footer"
    >
      <a
        :href="data.href"
        target="_blank"
        class="dashboard-modal__link"
      >
        {{ $t('buttons.view') }}
        <span class="dashboard-modal__link-icon" />
      </a>
    </template>
  </dashboard-modal>
</template>

<script>
import { getRatingClass } from '~/helpers/application-helpers'
import { getMapURLByServiceId, getImpactsMapURl } from '~/helpers/request-helpers'
import DashboardModal from '~/components/dashboard/DashboardModal'

export default {
  components: {
    DashboardModal
  },

  data () {
    return {
      active: false,
      data: undefined
    }
  },

  computed: {
    ratingClass () {
      return getRatingClass(this.data.selectedRating, this.$i18n.locale)
    }
  },

  created () {
    this.$root.$on('natural-capital-modal:open', this.onDashboardModalOpen)
  },

  beforeDestroy () {
    this.$root.$off('natural-capital-modal:open', this.onDashboardModalOpen)
  },

  methods: {
    onDashboardModalOpen (data) {
      this.data = data
      this.$nextTick(() => this.active = true)
    },

    getServiceUrl (category, id) {
      switch(category) {
      case 'ecosystem_services':
        return this.$url(getMapURLByServiceId(id))
      case 'impact_drivers':
        return this.$url(getImpactsMapURl())
      }
    },
  }
}
</script>
