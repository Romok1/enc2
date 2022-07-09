<template>
  <div
    v-if="countries"
    class="portfolio-builder"
  >
    <v-errors :errors="baseErrors.get('base')" />

    <ul class="portfolio-builder__items">
      <li
        v-for="(form, index) in forms"
        :key="`agriculture-form-${form.country}-${index}`"
        class="portfolio-builder__item"
      >
        <div
          v-show="form.$_active"
          class="portfolio-builder__form"
        >
          <v-form
            v-bind="{
              countries: availableCountries(form),
              errors: formErrors.index(index),
              index,
              form
            }"
            @change="onFormChange({ form: $event, index })"
            @delete="onFormDelete(index)"
          />
        </div>

        <v-toggler
          v-show="!form.$_active"
          :errors="formErrors.index(index)"
          :title="getTogglerTitle(form)"
          @edit="toggleActive(form)"
          @delete="onFormDelete(index)"
        />
      </li>
    </ul>

    <button
      class="portfolio-builder__button"
      @click="onAddButtonClick"
    >
      <span class="portfolio-builder__button-label">
        {{ t.ctas.add_button }}
      </span>
    </button>

    <Portal to="portfolio-generator-modal-footer">
      <div
        v-if="isSectorSelected"
        class="portfolio-generator-modal__footer"
      >
        <button
          class="portfolio-generator-modal__submit"
          @click.prevent="onSubmit"
        >
          {{ $t('biodiversity_goals.landing.modal.footer.button_text') }}
        </button>
      </div>
    </Portal>
  </div>
</template>

<script>
import agricultureFormsToQuerystring from '~/components/dashboard/biodiversity-goals/helpers/agriculture-forms-to-querystring'
import mixinGenerator from '~/components/dashboard/biodiversity-goals/portfolio-generators/mixins/mixin-generator'
import VErrors from '~/components/form/VErrors'
import VForm from './VForm'
import VToggler from '~/components/dashboard/biodiversity-goals/portfolio-generators/VToggler'

import { getAgricultureCountriesPath } from '~/helpers/request-helpers'

export default {
  components: {
    VErrors,
    VForm,
    VToggler
  },

  mixins: [mixinGenerator],

  beforeMount () {
    if (this.forms.length === 0) {
      this.addForm()
    }
  },

  computed: {
    isSectorSelected () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.selectedSector === 'agriculture'
    },

    isTabActive () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.selectedTab === 'manual'
    },

    forms () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.forms
    },

    queryString () {
      return agricultureFormsToQuerystring.call(this, this.forms)
    },

    t () {
      return this.$t('biodiversity_goals.portfolio.forms.agriculture')
    },

    countriesEndpoint () {
      return getAgricultureCountriesPath()
    },

    endpoint () {
      return this.generateEndpoint(`/${this.$i18n.locale}/tools/biodiversity-goals/agriculture-dashboard`)
    },

    validationEndpoint () {
      return this.generateEndpoint(`/${this.$i18n.locale}/tools/biodiversity-goals/validate-agriculture-dashboard`)
    }
  },

  methods: {
    addForm () {
      this.forms.push({
        $_active: true,
        country: undefined,
        crops_value: undefined,
        crops_area_type: 'area',
        livestock_value: undefined,
        livestock_area_type: 'area'
      })
    },

    getTogglerTitle (form) {
      return form.country ? this.countries.find(country => country.id === form.country).name : undefined
    },

    availableCountries (activeForm) {
      const selectedCountryIds = this.forms.map(form => form.country)

      return this.countries.filter(country =>
        selectedCountryIds.indexOf(country.id) === -1 || country.id === activeForm.country
      )
    },
  }
}
</script>
