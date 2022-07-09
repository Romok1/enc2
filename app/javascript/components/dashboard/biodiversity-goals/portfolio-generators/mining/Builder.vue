<template>
  <div
    v-if="countries"
    class="portfolio-builder"
  >
    <p>
      <i>{{ $t(translationPath('notice')) }}</i>
    </p>

    <VErrors :errors="baseErrors.get('base')" />

    <ul class="portfolio-builder__items">
      <li
        v-for="(form, index) in forms"
        :key="`mining-form-${form.company_id}-${index}`"
        class="portfolio-builder__item"
      >
        <div
          v-show="form.$_active"
          class="portfolio-builder__form"
        >
          <VForm
            v-bind="{
              errors: formErrors.index(index),
              form,
              index,
              locations: countries
            }"
            @change="onFormChange({ form: $event, index })"
            @delete="onFormDelete(index)"
          />
        </div>

        <VToggler
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
      {{ $t(translationPath('ctas.add_button')) }}
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
import mixinGenerator from '~/components/dashboard/biodiversity-goals/portfolio-generators/mixins/mixin-generator'
import VErrors from '~/components/form/VErrors'
import VForm from './VForm'
import VToggler from '~/components/dashboard/biodiversity-goals/portfolio-generators/VToggler'

import { getCountriesPath } from '~/helpers/request-helpers'

export default {
  components: {
    VErrors,
    VForm,
    VToggler,
  },

  mixins: [mixinGenerator],

  beforeMount () {
    if (this.forms.length === 0) {
      this.addForm()
    }
  },

  computed: {
    isSectorSelected () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.selectedSector === 'mining'
    },

    forms () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.forms
    },

    queryString () {
      const params = {
        mining_dashboard: this.forms.map(form => {
          return {
            company_id: form.company_id || null,
            locations: form.locations && form.locations.length ? form.locations : null
          }
        })
      }

      if (this.portfolio) {
        params.portfolio = this.portfolio.id
      }

      return this.$qs(params)
    },

    countriesEndpoint () {
      return getCountriesPath()
    },

    endpoint () {
      return this.generateEndpoint(`/${this.$i18n.locale}/tools/biodiversity-goals/mining-dashboard`)
    },

    validationEndpoint () {
      return this.generateEndpoint(`/${this.$i18n.locale}/tools/biodiversity-goals/validate-mining-dashboard`)
    }
  },

  methods: {
    addForm () {
      this.forms.push({
        $_active: true
      })
    },

    getTogglerTitle (form) {
      if (form.company_id) {
        return new Promise((resolve, reject) => {
          this.$http.get(`/${this.$i18n.locale}/companies/${form.company_id}`)
            .then(response => resolve(response.data.name))
            .catch(() => reject('__COMPANY_NAME__'))
        })
      }

      return Promise.resolve(this.$t(this.translationPath('unset_company_name')))
    },

    translationPath (path) {
      return `biodiversity_goals.portfolio.forms.mining.${path}`
    }
  }
}
</script>
