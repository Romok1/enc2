<template>
  <div class="list-box">
    <div class="list-box__title">
      <div class="list-box__title-text h2">
        {{ title }}
      </div>
    </div>
    <div class="list-box__container">
      <div
        class="flex list-box__flex-container"
        :class="flexContainerClass"
      >
        <slot name="flex-contents" />
        <div
          v-for="n in 3"
          class="list-box__filler"
          :class="itemFillerClass"
        />
      </div>
      <div class="list-box__footer">
        <slot name="footer" />
      </div>
    </div>
    <div
      v-if="isExpandable"
      class="list-box__toggle flex-center h3 hover--pointer" 
      :class="toggleClass" 
      @click="toggleExpanded"
    >
      {{ toggleMessage }}
      <i class="list-box__toggle-arrow arrow-svg--white" />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String
    },
    itemSize: {
      type: String,
      default: 'medium'
    },
    isExpandable: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      isExpanded: !this.isExpandable,
      buttons_t: this.$t('buttons')
    }
  },

  computed: {
    itemFillerClass () {
      switch (this.itemSize) {
      case 'small':
        return 'list-box__filler--small'
        break
      case 'medium':
        return 'list-box__filler--medium'
        break
      }
    },

    flexContainerClass () {
      return {
        'list-box__flex-container--small': this.itemSize === 'small',
        'list-box__flex-container--medium': this.itemSize === 'medium',
        'list-box__flex-container--collapsed': !this.isExpanded,
      }
    },

    toggleClass () {
      return {
        'list-box__toggle--expanded': this.isExpanded
      }
    },

    toggleMessage () {
      return this.isExpanded ? this.buttons_t.hide : this.buttons_t.view_more
    }
  },

  methods: {
    toggleExpanded() {
      this.isExpanded = !this.isExpanded 
    }
  }
}
</script>
