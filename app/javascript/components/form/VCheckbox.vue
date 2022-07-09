<template>
  <div
    class="v-checkbox"
    :class="{ 'v-checkbox--checked': checked }"
  >
    <input
      type="hidden"
      v-bind="{ ...$attrs, value: checked }"
    >
    <div
      ref="input"
      class="v-checkbox__input"
      tabindex="0"
      @click.prevent="toggleChecked"
      @keydown.space.prevent="toggleChecked"
    >
      <svg
        v-show="checked"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 9.596 7.5"
      >
        <g transform="translate(0 -10.918)">
          <path
            d="M3.371,15.9l4.98-4.98L9.6,12.193,3.371,18.418,0,15.048l1.275-1.275Z"
          />
        </g>
      </svg>
    </div>
    <label
      class="v-checkbox__label"
    >
      <slot>
        {{ label }}
      </slot>
    </label>
  </div>
</template>

<script>
export default {
  model: {
    prop: 'checked',
    event: 'change'
  },
  props: {
    checked: {
      default: false,
      type: Boolean,
    },
    label: {
      default: undefined,
      required: false,
      type: String,
    }
  },
  methods: {
    focusCheckbox () {
      this.$refs.input.focus()
    },
    toggleChecked () {
      this.$emit('change', this.checked ? false : true)
    }
  }
}
</script>
