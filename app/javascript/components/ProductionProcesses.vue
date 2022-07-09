<template>
  <div class="processes">
    <div class="processes__content">
      <h2 class="processes__title">
        {{ title_t }}
      </h2>
      <div class="processes__container">
        <div
          v-for="join in joins"
          :key="join.id"
          class="processes__process flex"
        >
          <h3 class="processes__name no-margin">
            {{ getProcessName(join) }}
          </h3>
          <span
            class="processes__justification flex"
            :class="getRatingClass(join)"
          >
            <p class="processes__justification-text paragraph--no-margin">
              <strong class="processes__join-rating-phrase">
                {{ getRatingPhrase(join) }}
              </strong>
              {{ getMaterialityDescription(join) }}
            </p>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getRatingClass } from '~/helpers/application-helpers'

export default {
  props: {
    joins: {
      default: () => [],
      type: Array
    }
  },
  data () {
    return {
      joinDescriptions: {}
    }
  },
  computed: {
    locale () {
      return this.$i18n.locale
    },

    title_t () {
      return this.$t('common.production_processes')
    }
  },

  watch: {
    joins () {
      this.setMaterialityDescriptionsAndProcessNames()
    }
  },

  created () {
    this.setMaterialityDescriptionsAndProcessNames()
  },


  methods: {
    setMaterialityDescriptionsAndProcessNames() {
      this.joins.forEach(join => {
        const joinDescription = {
          justification: join.justification,
          production_process_name: join.production_process.name
        }

        this.$set(this.joinDescriptions,this.getProcessId(join), joinDescription)
      })
    },

    getProcessId(join) {
      return join.production_process ? join.production_process.id : join.production_process_id
    },

    getRatingClass(join) {
      if (!join.rag) { return null }

      return getRatingClass(join.rag, this.locale)
    },

    getRatingPhrase(rating) {
      if (!rating.rag) { return '' }

      return this.$t('ratings.materiality_rating')[rating.rag.toLowerCase()]
    },

    getMaterialityDescription(join) {
      return this.joinDescriptions[this.getProcessId(join)] ?
        this.joinDescriptions[this.getProcessId(join)].justification :
        ''
    },

    getProcessName(join) {
      return this.joinDescriptions[this.getProcessId(join)] ?
        this.joinDescriptions[this.getProcessId(join)].production_process_name :
        ''
    }
  }
}
</script>
