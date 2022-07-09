<template functional>
  <div
    v-if="$options.hasErrors(props.errors)"
    class="errors-list"
    v-bind="data.attrs"
    :class="data.staticClass"
    :style="data.staticStyle"
  >
    <ul
      v-for="(error, index) in props.errors"
      :key="index"
      class="errors-list__items"
    >
      <li class="errors-list__item">
        <p class="errors-list__message">
          <span class="errors-list__icon" />
          {{ props.prefix }}{{ error }}
        </p>
      </li>
    </ul>
  </div>
</template>
<script>
export default {
  props: {
    errors: {
      default: () => [],
      type: Array,
      validator: errors => errors.every(error => typeof error === 'string')
    },
    prefix: {
      default: undefined,
      type: String
    }
  },
  hasErrors (errors) {
    return errors && errors.length > 0
  }
}
</script>
