<template>
  <button
    class="dashboard-button dashboard-button--edit"
    @click="onClick"
  >
    <span class="dashboard-button__text">
      {{ $t('buttons.edit') }}
    </span>

    <icon-pencil class="dashboard-button--icon" />
  </button>
</template>

<script>
import IconPencil from '~/icons/IconPencil'

export default {
  components: {
    IconPencil
  },

  methods: {
    onClick () {
      this.$emit('click')
      this.$root.$emit('edit-dashboard')
    }
  }
}
</script>