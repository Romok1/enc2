<template>
  <div
    v-if="show"
    id="pdf-portfolio-details"
    class="dashboard-details"
  >
    <h3 
      v-if="!inModal"
      class="dashboard-details__title"
    >
      {{ $t('biodiversity_goals.dashboard.shared.components.details.title') }}
    </h3>

    <ul class="dashboard-details__items">
      <li
        v-for="(item, index) in overview"
        :key="index"
        class="dashboard-details__item"
      >
        <p class="dashboard-details__text">
          <strong>{{ $t('biodiversity_goals.dashboard.mining.details.labels.company') }}</strong>
          {{ item.company.name }}
        </p>

        <p class="dashboard-details__text">
          <strong>
            {{ $t(`biodiversity_goals.dashboard.mining.details.labels.location`) }}
          </strong>
          {{ getItemLocations(item) }}
        </p>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: {
    inModal: {
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
    overview () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.overview
    },

    forms () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.forms
    },
  },

  created () {
    this.$root.$on('show-dashboard-details-modal', this.setOverview)

    if (!this.inModal) {
      this.setOverview()
    }
  },

  beforeDestroy () {
    this.$root.$off('show-dashboard-details-modal', this.setOverview)
  },

  methods: {
    getItemLocations (item) {
      return item.countries.length ?
        item.countries.map(country => country.name).join(', ') :
        this.$t('biodiversity_goals.dashboard.mining.details.values.global')
    },

    setOverview () {
      const params = {
        mining_dashboard: this.forms.map(form => {
          return {
            company_id: form.company_id || null,
            locations: form.locations && form.locations.length ? form.locations : null
          }
        })
      }
      const queryString = this.$qs(params)

      this.$http.get(`/${this.$i18n.locale}/tools/biodiversity-goals/mining-dashboard/overview?${queryString}`)
        .then(response => {
          this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateOverview', response.data)
        })
        .finally(() => {
          this.show = true
        })
    }
  }
}
</script>
