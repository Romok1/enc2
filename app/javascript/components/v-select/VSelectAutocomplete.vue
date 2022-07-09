<template>
  <div class="v-select v-select--search relative">
    <div
      v-if="config.label"
      class="v-select__label"
    >
      <label
        :for="toggleId"
        class="v-select__selection"
      >{{ config.label }}</label>
      <slot name="label-icon" />
    </div>

    <div class="v-select__click-area">
      <div class="v-select__search relative">
        <label
          class="screen-reader"
          :for="selectControlId"
        >{{ getSearchLabel(config) }}</label>

        <autocomplete 
          :id="selectControlId"
          :disabled="disabled"
          :placeholder="placeholderText"
          :autocomplete-callback="autocompleteCallback"
          :error-messages="errorMessages"
          @submit="selectOption"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Autocomplete from '~/components/autocomplete/Autocomplete'
import mixinIds from '~/mixins/mixin-ids'

export default {
  components: {
    Autocomplete
  },

  mixins: [mixinIds],

  props: {
    config: {
      type: Object,
      required: true
    },
    autocompleteCallback: {
      type: Function,
      required: true
    },
    fetchOption: {
      type: Function,
      required: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: ''
    },
    selectedId: {
      type: [Number, String],
      default: undefined
    }
  },

  data () {
    return {
      toggleId: 'v-select-toggle-' + this.config.id,
      selectControlId: 'v-select-search-' + this.config.id,
      selected: undefined
    }
  },

  computed: {
    errorMessages () {
      return this.$t('errors.autocomplete_errors')
    },

    placeholderText () {
      const placeholder = this.placeholder || `- ${this.$t('buttons.enter')} -`

      return this.selected ? this.selected.name : placeholder
    },

    selectedOptionsId () {
      return `${this.getComponentId()}-selected-options`
    },
  },

  watch: {
    selectedId () {
      this.updateSelectedOption()
    }
  },

  created () {
    this.updateSelectedOption()
  },

  methods: {
    updateSelectedOption () {
      if (this.selectedId === undefined) {
        this.selectOption(undefined)
      } else if (
        !this.selected || 
        this.selectedId !== this.selected.id
      ) {
        this.fetchOption(this.selectedId).then(res => {
          this.selectOption(res.data)
        })
      }
    },

    selectOption (option) {
      this.selected = option
      this.$emit(
        'update:selected-option-id', 
        option ? option.id : undefined
      )
    },

    getSearchLabel (filterConfig) {
      return `${filterConfig.label} ${this.$t('buttons.search')}`
    },
  }
}
</script>