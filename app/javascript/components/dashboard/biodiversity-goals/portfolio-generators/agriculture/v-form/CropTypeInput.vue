<template>
  <div class="crop-type-input">
    <label
      class="portfolio-generator-form__label"
      :for="id(index, areaType)"
    >
      <div class="portfolio-generator-form__label-text">
        {{ labelTextTranslation }}
      </div>
      <button
        class="crop-type-input__toggle"
        :class="{ 'crop-type-input__toggle--active': expanded }"
        :title="toggleText"
        :aria-expanded="expanded ? 'true' : 'false'"
        @click.prevent="onToggleClick"
      />
    </label>
    <div v-show="expanded">
      <VField>
        <VCheckbox
          class="portfolio-generator-form__checkbox"
          :checked="areaType === 'turnover'"
          :disabled="busy"
          @change="onCheckboxToggle"
        >
          {{ $t(translationPath('labels.toggle_turnover')) }}
        </VCheckbox>
      </VField>
      <VField :error="errors.has(areaType)">
          <div
            class="portfolio-generator-form__label-description"
            v-html="labelDescriptionTranslation"
          />
        <input
          class="portfolio-generator-form__input"
          :disabled="busy"
          :value="form[`${cropType}_value`]"
          placeholder="0"
          type="number"
          min="1"
          @input="onUpdate(`${cropType}_value`, $event.target.value)"
        >
        <VErrors :errors="errors.get(cropType)" />
      </VField>
    </div>
  </div>
</template>
<script>
import {
  id,
  onUpdate,
  update,
} from '~/components/dashboard/biodiversity-goals/portfolio-generators/common/form-methods'
import { mapGetters } from 'vuex'

import ErrorBag from '~/classes/ErrorBagV2'
import VCheckbox from '~/components/form/VCheckbox'
import VErrors from '~/components/form/VErrors'
import VField from '~/components/form/VField'

export default {
  components: {
    VCheckbox,
    VErrors,
    VField,
  },

  model: {
    event: 'change',
    prop: 'form'
  },

  props: {
    busy: {
      type: Boolean,
      required: true
    },

    cropType: {
      type: String,
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
    },

    initalizeExpanded: {
      type: Boolean,
      default: true
    }
  },

  data () {
    return {
      expanded: false
    }
  },

  created () {
    this.expanded = this.initalizeExpanded === true
  },

  computed: {
    ...mapGetters('biodiversityGoals/dashboard',  [
      'areaTypes'
    ]),

    areaType () {
      return this.form[`${this.cropType}_area_type`] || this.areaTypes[0]
    },

    labelDescriptionTranslation () {
      return this.$t(
        this.translationPath(`labels.${this.areaType}_subtext`),
        {
          attribute: this.$t(this.translationPath(`attributes.${this.cropType}`))
        }
      )
    },

    labelTextTranslation () {
      return this.$t(
        this.translationPath(`labels.${this.areaType}`),
        {
          attribute: this.$t(this.translationPath(`attributes.${this.cropType}`))
        }
      )
    },

    toggleText () {
      return this.$t(`buttons.${this.expanded ? 'collapse' : 'expand'}`)
    }
  },

  methods: {
    /**
     * Common methods to the component
     */
    id,
    onUpdate,
    update,

    booleanToAreaType (useTurnover) {
      return useTurnover ? 'turnover' : 'area'
    },

    onCheckboxToggle (useTurnover) {
      this.$emit('change', {
        ...this.form,
        [`${this.cropType}_area_type`]: this.booleanToAreaType(useTurnover),
        [`${this.cropType}_value`]: undefined
      })
    },

    onToggleClick () {
      this.expanded = !this.expanded
    },

    translationPath (path) {
      return `biodiversity_goals.portfolio.forms.agriculture.${path}`
    }
  }
}
</script>