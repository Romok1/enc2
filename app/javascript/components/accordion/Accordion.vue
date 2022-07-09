<template>
  <div>
    <slot />
  </div>
</template>

<script>
export default {
  name: 'Accordion',

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      children: this.$children
    }
  },

  mounted () {
    this.$root.$on(this.id, this.toggleAccordionContent)
  },

  methods: {
    toggleAccordionContent (id) {
      // toggle the accordion content as well as hide layers from inactive accordion items
      this.children.forEach(child => {
        child.isActive = child.id === id && child.isActive !== true
        if (typeof child.toggleId !== 'undefined') {
          this.$root.$emit(child.toggleId, child.isActive)
        }
      })
    }
  }
}
</script>
