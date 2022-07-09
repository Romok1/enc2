<template>
  <div
    :class="{
      'portfolio-generator-toggler--invalid': errors.any()
    }"
    class="portfolio-generator-toggler"
  >
    <div class="portfolio-generator-toggler__title">
      {{ renderTitle }}
    </div>
    <button
      class="portfolio-generator-toggler__button portfolio-generator-toggler__button--edit"
      :title="$t('labels.edit')"
      @click="onEditClick"
    >
      <icon-pencil class="portfolio-generator-toggler__icon-edit" />
    </button>
    <button
      class="portfolio-generator-toggler__button portfolio-generator-toggler__button--delete"
      :title="$t('labels.delete')"
      @click="onDeleteClick"
    >
      <icon-close />
    </button>
  </div>
</template>

<script>
import ErrorBag from '~/classes/ErrorBagV2'
import IconClose from '~/icons/IconClose'
import IconPencil from '~/icons/IconPencil'

export default {
  components: {
    IconClose,
    IconPencil
  },

  props: {
    errors: {
      type: Object,
      default: () => new ErrorBag()
    },
    title: {
      type: [Promise, String],
      default: undefined
    }
  },

  data () {
    return {
      renderTitle: '...'
    }
  },

  created () {
    if (this.title instanceof Promise) {
      this.title.then(title => this.renderTitle = title)
    } else {
      this.renderTitle = this.title
    }
  },

  methods: {
    onEditClick () {
      this.$emit('edit')
    },

    onDeleteClick () {
      this.$emit('delete')
    }
  }
}
</script>
