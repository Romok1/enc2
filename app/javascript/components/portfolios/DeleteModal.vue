<template>
  <modal
    v-model="show"
    class="portfolios-delete-modal"
  >
    <loading-spinner v-if="busy" />
    <div
      v-else-if="portfolio"
      class="portfolios-delete-modal__container"      
    >
      <v-errors :errors="getErrors('base')" />

      <form @submit.prevent="onSubmit">
        <div class="portfolios-delete-modal__inner-container">
          <icon-bin class="portfolios-delete-modal__icon" />
          <h2 class="portfolios-delete-modal__heading">
            {{ $t('portfolios.delete_modal.cta', { portfolio_name: portfolio.name }) }}
          </h2>

          <p class="portfolios-delete-modal__body">
            {{ $t('portfolios.delete_modal.description') }}
          </p>

          <div class="portfolios-delete-modal__actions">
            <button
              class="portfolios-delete-modal__cancel"
              type="cancel"
              @click.prevent="close"
            >
              {{ $t('buttons.cancel') }}
            </button>

            <button
              class="portfolios-delete-modal__submit"
              type="submit"
            >
              {{ $t('buttons.confirm') }}
            </button>
          </div>
        </div>
      </form>
    </div>
  </modal>
</template>

<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import IconBin from '~/icons/IconBin'
import LoadingSpinner from '~/common/LoadingSpinner'
import Modal from '~/components/modal/Modal'

export default {
  components: {
    IconBin,
    LoadingSpinner,
    Modal
  },

  mixins: [
    errorsMixin
  ],

  data () {
    return {
      busy: false,
      portfolio: undefined,
      show: false
    }
  },

  created () {
    this.$root.$on('show-portfolios-delete-modal', ({ show, portfolio }) => {
      if (show) {
        this.open(portfolio)
      } else {
        this.close()
      }
    })
  },

  methods: {
    close () {
      this.portfolio = undefined
      this.show = false
    },

    open (portfolio) {
      this.portfolio = portfolio
      this.show = true
    },

    onSubmit () {
      this.busy = true

      this.$http.delete(`/${this.$i18n.locale}/portfolios/${this.portfolio.id}`)
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => (this.busy = false))
    },

    onSuccess () {
      this.$root.$emit('portfolio-deleted', this.portfolio)
      this.$emit('deleted', this.portfolio)
      this.close()
    },

    onError (e) {
      switch (e.response.status) {
      case UNPROCESSABLE_ENTITY:
        this.setErrors(e.response.data.errors)
        this.$emit('errors', e.response.data.errors)
        break
      default:
        this.setErrors({ base: [this.$t('errors.messages.unknown')] })
      }
    }
  }
}
</script>