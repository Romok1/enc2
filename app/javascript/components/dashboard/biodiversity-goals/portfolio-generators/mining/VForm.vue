<template>
  <div
    :class="{
      'portfolio-generator-form--invalid': errors.any()
    }"
    class="portfolio-generator-form portfolio-generator-form--mining"
  >
    <div class="portfolio-generator-form__legend">
      {{ t.legend }}
    </div>

    <div class="portfolio-generator-form__data">
      <button
        class="portfolio-generator-form__close"
        @click.prevent="onCloseButtonClick"
      >
        <icon-close class="portfolio-generator-form__close-icon" />
      </button>

      <v-errors :errors="errors.get('base')" />

      <v-field :error="errors.has('company_id')">
        <label
          class="portfolio-generator-form__label"
          :for="id(index, 'company_id')"
        >
          <div class="portfolio-generator-form__label-text">
            {{ t.labels.company }}
          </div>
          <div
            class="portfolio-generator-form__label-description"
            v-html="t.labels.company_subtext /* eslint-disable-line vue/no-v-html */"
          />
        </label>
        <v-select-autocomplete
          class="portfolio-generator-form__input"
          :config="{ id: id(index, 'company_id') }"
          :autocomplete-callback="autocompleteCallback"
          :fetch-option="fetchCompany"
          :disabled="$parent.busy"
          :selected-id="form.company_id"
          @update:selected-option-id="onUpdate('company_id', $event)"
        />
        <v-errors :errors="errors.get('company_id')" />
      </v-field>
      <v-field :error="errors.has('locations')">
        <label
          class="portfolio-generator-form__label"
          :for="id(index, 'locations')"
        >
          <div class="portfolio-generator-form__label-text">
            {{ t.labels.locations }}
          </div>
          <div
            class="portfolio-generator-form__label-description"
            v-html="t.labels.locations_subtext /* eslint-disable-line vue/no-v-html */"
          />
        </label>
        <v-multiselect-searchable
          class="portfolio-generator-form__input"
          :config="locationMultiselectConfig"
          :options="locations"
          :disabled="$parent.busy"
          :selected="formLocations"
          @update:selected-option="onUpdate('locations', $event)"
        />
        <v-errors :errors="errors ? errors['locations'] : []" />
      </v-field>
    </div>

    <p
      v-if="!hasMines"
      class="portfolio-generator-form__no-mines"
    >
      {{ $t('biodiversity_goals.portfolio.forms.mining.labels.no_mines_text') }}
    </p>

    <p class="portfolio-generator-form__small-print">
      {{ $t('biodiversity_goals.portfolio.forms.mining.labels.data_credit') }}
    </p>
  </div>
</template>

<script>
import {
  id,
  onCloseButtonClick,
  onUpdate,
  update
} from '~/components/dashboard/biodiversity-goals/portfolio-generators/common/form-methods'

import ErrorBag from '~/classes/ErrorBagV2'
import IconClose from '~/icons/IconClose'
import VErrors from '~/components/form/VErrors'
import VField from '~/components/form/VField'
import VMultiselectSearchable from '~/components/v-select/VMultiselectSearchable'
import VSelectAutocomplete from '~/components/v-select/VSelectAutocomplete'


export default {
  components: {
    IconClose,
    VErrors,
    VField,
    VMultiselectSearchable,
    VSelectAutocomplete,
  },

  model: {
    event: 'change',
    prop: 'form'
  },

  props: {
    locations: {
      type: Array,
      required: true
    },

    errors: {
      type: Object,
      default: () => new ErrorBag()
    },

    form: {
      type: Object,
      required: true
    },

    index: {
      type: Number,
      required: true
    }
  },

  data () {
    return {
      hasMines: true
    }
  },

  computed: {
    autocompleteCallback () {
      return searchTerm => this.getAutocompletePromise(searchTerm)
    },

    formLocations () {
      return Array.isArray(this.form.locations) ? this.form.locations : []
    },

    locationMultiselectConfig () {
      return { id: this.id(this.index, 'locations'), hasSearch: true }
    },

    queryString () {
      const params = {
        mining_dashboard: [
          {
            company_id: this.form.company_id || null,
            locations: this.form.locations && this.form.locations.length ? this.form.locations : null
          }
        ]
      }

      return this.$qs(params)
    },

    t () {
      return this.$t('biodiversity_goals.portfolio.forms.mining')
    }
  },

  methods: {
    /**
     * Common methods to the component
     */
    id,
    onCloseButtonClick,

    onUpdate (property, value) {
      onUpdate.call(this, property, value)
      this.$nextTick(this.setMinesPresence)
    },

    update,

    fetchCompany (id) {
      return this.$http.get(`/${this.$i18n.locale}/companies/${id}`)
    },

    getAutocompletePromise (searchTerm) {
      return this.$http.get(`/${this.$i18n.locale}/companies_autocomplete?term=${searchTerm}`)
    },

    setMinesPresence () {
      const url = `/${this.$i18n.locale}/tools/biodiversity-goals/mines-present?${this.queryString}`

      this.$http.get(url)
        .then(response => {
          this.hasMines = response.data
        })
        .catch(error => {
          console.error(error)
        })
    }
  }
}
</script>
