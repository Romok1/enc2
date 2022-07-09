<template>
  <button
    class="dashboard-button dashboard-button--save"
    @click="onClick"
  >
    <span class="dashboard-button__text">
      {{ $t('buttons.save') }}
    </span>

    <icon-save class="dashboard-button--icon" />
  </button>
</template>

<script>
import IconSave from '~/icons/IconSave'

export default {
  components: {
    IconSave
  },

  methods: {
    onClick () {
      this.$emit('click')
      this.$root.$emit('show-dashboard-save-modal', true)
    }
  }
}
</script>
