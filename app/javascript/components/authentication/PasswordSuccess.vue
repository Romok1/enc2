<template>
  <div class="devise">
    <div class="devise__container">
      <icon-tick
        class="devise__icon--tick"
        color="#000"
      />

      <h2>{{ $t('devise.confirmations.password_updated') }}</h2>

      <p class="devise__description">
        {{ $t('devise.confirmations.password_updated_message') }}
      </p>
      
      <div class="devise__links">
        <a 
          class="button button--green button--medium"
          :href="$url('/tools')"
        >
          {{ $t('devise.ctas.dashboard') }}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import IconTick from '~/icons/IconTick'

export default {
  components: { IconTick }
}
</script>