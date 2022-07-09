<template>
  <div>
    <slot />
  </div>
</template>
<script>
export default {
  props: {
    fallbackLocale: { required: true, type: String },
    locale: { required: true, type: String },
    messages: { required: true, type: Object }
  },

  created () {
    this.$i18n.setFallbackLocale = this.fallbackLocale
    this.$i18n.locale = this.locale
    this.$i18n.setLocaleMessage(this.locale, this.messages)
    this.$http.defaults.headers.common['Accept-Language'] = this.locale
  }
}
</script>
  