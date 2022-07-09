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
          <strong>{{ $t(translationPath('country_label')) }}</strong>
          {{ item.country.name }}
        </p>

        <template v-for="cropType in cropTypes">
          <p
            v-if="hasValue({ cropType, item })"
            class="dashboard-details__text"
          >
            <strong>{{ getLabelTranslation({ cropType, item }) }}</strong>
            {{ getValueTranslation({ cropType, item }) }}
          </p>
        </template>
      </li>
    </ul>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import agricultureFormsToQuerystring from '~/components/dashboard/biodiversity-goals/helpers/agriculture-forms-to-querystring'

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
    ...mapGetters('biodiversityGoals/dashboard',  [
      'cropTypes'
    ]),

    overview () {
      /**
       * Response:
       * 
       * {
       *   country: {
       *     id: Number,
       *     iso_3: String,
       *     name: String
       *   },
       *   crops_value: String,
       *   crops_area_type: String,
       *   livestock_value: String,
       *   livestock_area_type: String
       * }
       * 
       */
      return this.$store.state.biodiversityGoals.portfolioGenerator.overview
    },

    forms () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.forms
    }
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
    hasValue ({ cropType, item }) {
      return  this.getValue({ cropType, item }) > 0
    },

    getValue ({ cropType, item }) {
      return item[`${cropType}_value`]
    },

    getAreaType ({ cropType, item }) {
      return item[`${cropType}_area_type`]
    },

    getLabelTranslation ({ cropType, item }) {
      return this.$t(this.translationPath(`area.labels.${this.getAreaType({ cropType, item })}.${cropType}`))
    },

    getValueTranslation ({ cropType, item }) {
      return this.$t(
        this.translationPath(`area.values.${this.getAreaType({ cropType, item })}`),
        {
          value: this.getValue({ cropType, item })
        }
      )
    },

    setOverview () {
      const queryString = agricultureFormsToQuerystring.call(this, this.forms)

      this.$http.get(`/${this.$i18n.locale}/tools/biodiversity-goals/agriculture-dashboard/overview?${queryString}`)
        .then(response => {
          this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateOverview', response.data)
        })
        .finally(() => {
          this.show = true
        })
    },

    translationPath (path) {
      return `biodiversity_goals.dashboard.agriculture.details.${path}`
    }
  }
}
</script>
