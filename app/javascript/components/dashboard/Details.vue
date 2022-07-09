<template>
  <div class="dashboard-panel__details">
    <p class="dashboard-panel__details-text">
      {{ $t('portfolios.details.applied_filters') }}
      <button
        class="dashboard-panel__details-modal-trigger"
        @click="onClick"
      >
        {{ $t('portfolios.details.trigger_text') }}
      </button>
    </p>
  </div>
</template>

<script>
export default {
  methods: {
    onClick () {
      this.$emit('click')
      this.$root.$emit('show-dashboard-details-modal', true)
    }
  }
}
</script>
