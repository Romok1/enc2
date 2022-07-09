<template>
  <div class="ratings-record">
    <h5 class="ratings-record__heading">
      {{ record.name }}
    </h5>
    <p
      class="ratings-record__text"
      v-html="recordText"
    />
    <p
      class="ratings-record__link"
    >
      {{ $t('buttons.more_info') }}
    </p>
    <button
      class="ratings-record__modal-trigger"
      @click="onClick"
    />
  </div>
</template>

<script>
import { getEcosystemServicePath, getImpactDriverPath } from '~/helpers/request-helpers'
export default {

  props: {
    category: {
      type: String,
      required: true,
      validator: name => name.match(/impact_drivers|ecosystem_services/)
    },
    record: {
      type: Object,
      required: true
    },
    selectedRating: {
      type: String,
      default: ''
    }
  },

  computed: {
    modalText () {
      return this.$t(`natural_capital.dashboard.components.${this.category}_list.modal_text`)
    },

    modalUrl () {
      switch (this.category) {
      case 'ecosystem_services':
        return getEcosystemServicePath(this.record.id)
      case 'impact_drivers':
        return getImpactDriverPath(this.record.id)
      default:
        return ''
      }
    },

    recordText () {
      return this.$t(
        `natural_capital.dashboard.components.${this.category}_list.record_text`,
        {
          count: this.record.productionProcesses.length,
          selectedRating: this.selectedRating
        }
      )
    },
  },

  methods: {
    onClick () {
      this.$root.$emit('natural-capital-modal:open', {
        name: this.record.name,
        text: this.modalText,
        items: this.record.productionProcesses,
        selectedRating: this.selectedRating,
        dataType: 'production_processes',
        href: this.$url(this.modalUrl)
      })
    }
  }
}
</script>
