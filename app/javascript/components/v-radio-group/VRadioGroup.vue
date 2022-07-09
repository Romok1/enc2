<template>
  <div class="v-radio__group">
    <legend class="v-radio__legend">
      {{ buttons_t.view }}:
    </legend>
    <div
      v-for="(option, i) in options"
      :id="'input-group-' + i"
      :key="option.id + '-' + i"
      class="v-radio__input-group"
      name="radio-options"
    >
      <input
        :id="getInputId(option)"
        v-model="selectedInternal"
        :name="getGroupName"
        type="radio"
        class="v-radio__input"
        :value="getOptionValue(option)"
        :disabled="option.disabled"
      >
      <label
        :for="getInputId(option)"
        class="v-radio__label"
      >
        {{ option.name }}
      </label>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    options: {
      required: true,
      type: Array
    },
    groupName: {
      default: '',
      type: String
    },
    selected: {
      default: '',
      type: [Number, String]
    }
  },

  data() {
    return {
      selectedInternal: null,
      buttons_t: this.$t('buttons')
    }
  },

  computed: {
    getGroupName () {
      return this.groupName ? `${this.groupName}-${this._uid}` : `radioGroup-${this._uid}`
    }
  },

  watch: {
    selected () {
      this.setSelectedInternal()
    },

    selectedInternal () {
      this.$emit('update:selected', this.selectedInternal)
    }
  },

  created() {
    this.setSelectedInternal()
  },

  methods: {
    getInputId (option) {
      return `${option.id}-${this._uid}`
    },

    getOptionValue (option) {
      return option.value ? option.value : option.id
    },

    setSelectedInternal () {
      this.selectedInternal = this.selected === '' ?
        this.options[0].value :
        this.selected
    },
  }
}
</script>
