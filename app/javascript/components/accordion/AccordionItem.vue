<template>
  <div
    class="accordion__item"
    :class="{ 'accordion__item--disabled': !hasChildren }"
  >
    <button
      :id="toggleId"
      :aria-haspopup="true"
      :aria-controls="contentId"
      :aria-expanded="isActive"
      :class="['accordion__trigger button--unstyled flex', {'is-active' : isActive }]"
      @click="toggleAccordion"
    >
      <label
        class="accordion__item-label no-margin"
        :for="toggleId"
      >
        {{ title }}
        <em
          v-if="!hasChildren"
          class="not-available-text"
        > - {{ common_t.not_available }}</em>
      </label>
    </button>

    <transition name="accordion-toggle">
      <div
        v-show="isActive"
        :id="contentId"
        role="region"
        class="accordion__target"
      >
        <div class="accordion__content">
          <slot />
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'AccordionItem',

  props: {
    id: {
      type: String,
      required: true
    },
    accordionId: {
      type: String,
      required: true
    },
    toggleId: {
      type: String,
      default: undefined
    },
    title: {
      type: String,
      default: undefined
    },
    open: Boolean
  },

  data () {
    return {
      contentId: 'accordion-content-' + this.id,
      isActive: this.open,
      hasChildren: false,
      common_t: this.$t('common')
    }
  },

  mounted () {
    this.hasChildren = this.$slots.default !== undefined
  },

  methods: {
    toggleAccordion () {
      this.$root.$emit(this.accordionId, this.id)
    },
  },
}
</script>

<style lang="scss">
  @keyframes open {
    from { max-height: 0; }
    to { max-height: 500px; }
  }

  @keyframes close {
    from { max-height: 500px; }
    to { max-height: 0; }
  }

  .accordion-toggle-enter-active {
    animation: open .4s forwards ease-in;
  }

  .accordion-toggle-leave-active {
    animation: close .4s forwards ease-out;
  }

  .accordion {
    &__trigger {
      cursor: pointer;
    }

    &__target {
      overflow: hidden;
      height: auto;
    }
  }
</style>
