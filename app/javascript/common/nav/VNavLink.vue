<template functional>
  <a
    role="menuitem"
    class="nav__select hover--pointer"
    v-bind="data.attrs"
    :class="data.staticClass"
    :style="data.staticStyle"
    :href="parent.$url(props.item.url)"
    :data-method="props.item.method"
    :title="$options.truncate(props.item.label) === props.item.label ? props.item.label : undefined"
  >
    {{ $options.truncate(props.item.label) }}
  </a>
</template>

<script>
import { truncate } from 'lodash'

const TRUNCATE_THRESHOLD = 24

export default {
  props: {
    item: {
      required: true,
      type: Object
    }
  },
  truncate (text) {
    return truncate(text, { length: TRUNCATE_THRESHOLD })
  }
}
</script>
