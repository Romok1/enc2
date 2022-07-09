<template>
  <div
    :class="{
      'portfolio-generator-form--invalid': errors.any()
    }"
    class="portfolio-generator-form portfolio-generator-form--agriculture"
  >
    <div class="portfolio-generator-form__legend">
      {{ $parent.t.legend }}
    </div>

    <div class="portfolio-generator-form__data">
      <button
        class="portfolio-generator-form__close"
        @click.prevent="onCloseButtonClick"
      >
        <IconClose class="portfolio-generator-form__close-icon" />
      </button>

      <VErrors :errors="errors.get('base')" />

      <div class="portfolio-generator-form__section portfolio-generator-form__section--country">
        <VField :error="errors.has('country')">
          <label
            class="portfolio-generator-form__label"
            :for="id(index, 'country')"
          >
            {{ $parent.t.labels.location }}
          </label>
          <VSelectSearchable
            class="portfolio-generator-form__input"
            :config="countrySelectConfig"
            :options="countries"
            :disabled="$parent.busy"
            :selected="form.country"
            @update:selected-option="onUpdate('country', $event)"
          />
          <VErrors :errors="errors.get('country')" />
        </VField>
      </div>

      <div
        v-for="(cropType, index) in cropTypes"
        :key="cropType"
        :class="`portfolio-generator-form__section portfolio-generator-form__section--${cropType}`"
      >
        <CropTypeInput
          v-bind="{
            busy: $parent.busy,
            cropType,
            errors,
            form,
            index,
            initalizeExpanded: index === 0
          }"
          @change="onCropTypeInputUpdate"
        />
      </div>
    </div>

  </div>
</template>

<script>
import {
  id,
  onCloseButtonClick,
  onUpdate,
  update
} from '~/components/dashboard/biodiversity-goals/portfolio-generators/common/form-methods'
import { mapGetters } from 'vuex'
import CropTypeInput from './v-form/CropTypeInput'
import ErrorBag from '~/classes/ErrorBagV2'
import IconClose from '~/icons/IconClose'
import VCheckbox from '~/components/form/VCheckbox'
import VErrors from '~/components/form/VErrors'
import VField from '~/components/form/VField'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: {
    CropTypeInput,
    IconClose,
    VCheckbox,
    VErrors,
    VField,
    VSelectSearchable,
  },

  model: {
    event: 'change',
    prop: 'form'
  },

  props: {
    countries: {
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

  computed: {
    ...mapGetters('biodiversityGoals/dashboard',  [
      'cropTypes'
    ]),

    countrySelectConfig () {
      return { id: this.id(this.index, 'country'), hasSearch: true }
    }
  },

  methods: {
    /**
     * Common methods to the component
     */
    id,
    onCloseButtonClick,
    onUpdate,
    update,

    onCropTypeInputUpdate (form) {
      this.$emit('change', form)
    },

    translationPath (path) {
      return `biodiversity_goals.portfolio.forms.agriculture.${path}`
    }
  }


}
</script>
