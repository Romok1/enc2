<template>
  <modal
    v-model="show"
    class="dashboard-save-modal"
    @close="overwrite = false"
  >
    <loading-spinner v-if="busy" />
    <template v-else>
      <v-errors :errors="getErrors('base')" />

      <form
        class="dashboard-save-modal__form"
        @submit.prevent="onSubmit"
      >
        <template v-if="overwrite">
          <icon-triangular-warning-sign class="dashboard-save-modal__overwrite-icon" />
          <p class="dashboard-save-modal__overwrite-body">
            {{ $t('portfolios.delete_modal.overwrite_description', { portfolio_name: form.name }) }}
          </p>

          <div class="dashboard-save-modal__actions">
            <button
              class="dashboard-save-modal__confirm"
              type="submit"
            >
              {{ $t('buttons.confirm') }}
            </button>

            <button
              class="dashboard-save-modal__cancel"
              type="button"
              @click.prevent="overwrite = false"
            >
              {{ $t('buttons.cancel') }}
            </button>
          </div>
        </template>
        <template v-else>
          <h2 class="dashboard-save-modal__title">
            {{ $t('portfolios.form.title') }}
          </h2>

          <v-field :error="hasErrors('name')">
            <label for="portfolio_name">{{ $t('portfolios.form.labels.name') }}</label>
            <input
              v-model="form.name"
              v-focus
              :disabled="busy"
              type="text"
            >
            <v-errors
              :errors="getErrors('name')"
              :prefix="$t('portfolios.form.labels.name') + ' '"
            />
          </v-field>

          <button
            class="dashboard-save-modal__save"
            type="submit"
          >
            {{ $t('buttons.save') }}
          </button>
        </template>
      </form>
    </template>
  </modal>
</template>

<script>
import {
  UNPROCESSABLE_ENTITY
} from '~/helpers/http-status-codes'
import errorsMixin from '~/mixins/mixin-errors'
import IconTriangularWarningSign from '~/icons/IconTriangularWarningSign'
import LoadingSpinner from '~/common/LoadingSpinner'
import Modal from '~/components/modal/Modal'
import VField from '~/components/form/VField'

export default {
  components: {
    IconTriangularWarningSign,
    LoadingSpinner,
    Modal,
    VField,
  },

  mixins: [
    errorsMixin,
  ],

  props: {
    type: {
      type: String,
      required: true
    },

    loadedPortfolio: {
      type: Object,
      default: undefined
    }
  },

  data () {
    return {
      busy: false,
      form: {
        name: undefined
      },
      overwrite: false,
      portfolioLoaded: false,
      show: false
    }
  },

  computed: {
    requestStructure () {
      if (this.type === 'natural_capital') {
        return this.$store.state.naturalCapital.dashboard.selections
      }

      // assume it is a biodiversity goals module
      return { [`${this.type}_dashboard`]: this.$store.state.biodiversityGoals.portfolioGenerator.forms }
    },

    portfolio () {
      return this.$store.state.portfolio
    }
  },

  watch: {
    portfolio (portfolio) {
      this.$set(this.form, 'name', portfolio.name)
    }
  },

  created () {
    this.$root.$on('show-dashboard-save-modal', show => {
      this.show = show
    })

    this.loadPortfolio()
    this.$root.$on('load-portfolio', this.loadPortfolio)
  },

  beforeDestroy () {
    this.$root.$off('load-portfolio', this.loadPortfolio)
    // Remove portfolio as turbolinks will persist the store state after page change
    this.updatePortfolio(undefined)
  },

  methods: {
    close () {
      this.setErrors()
      this.show = false
    },

    onSubmit () {
      this.busy = true

      this.$http({
        url: `/${this.$i18n.locale}/portfolios` + (this.portfolio ? `/${this.portfolio.id}` : ''),
        method: this.portfolio ? 'patch' : 'post',
        data: {
          overwrite: this.overwrite,
          portfolio: {
            ...this.form,
            portfolio_type: this.type,
            request_structure: this.requestStructure
          }
        }
      })
        .then(this.onSuccess)
        .catch(this.onError)
        .finally(() => (this.busy = false))
    },

    onSuccess (response) {
      if (this.type === 'natural_capital') {
        this.updatePortfolio(response.data)
        this.setPortfolioInAddressBar(this.portfolio)
        this.close()
      } else {
        window.location.href = this.getUrlWithPortfolioParam(response.data)
        this.close()
      }
    },

    onError (e) {
      console.error(e)
      this.overwrite = e.response.data.hasOwnProperty('prompt_overwrite') && e.response.data.prompt_overwrite

      switch (e.response.status) {
      case UNPROCESSABLE_ENTITY:
        this.setErrors(e.response.data.errors)
        this.$emit('errors', e.response.data.errors)
        break
      default:
        this.setErrors({ base: [this.$t('errors.messages.unknown')] })
      }
    },

    setPortfolioInAddressBar (portfolio) {
      window.history.pushState(
        { portfolio },
        'update portfolio',
        this.getUrlWithPortfolioParam(portfolio)
      )
    },

    getUrlWithPortfolioParam (portfolio) {
      const url = new URL(window.location.pathname, window.origin)

      url.searchParams.set('portfolio', portfolio.id)

      return url.toString()
    },

    updatePortfolio (portfolio) {
      this.$store.dispatch('updatePortfolio', portfolio)
    },

    getPortfolioIdFromAddressBar () {
      const url = new URL(window.location.href)

      if (url.searchParams.has('portfolio')) {
        const portfolioId = parseInt(url.searchParams.get('portfolio'))

        if (portfolioId) {
          return portfolioId
        } else {
          console.error('Incorrect portfolio ID', { portfolioId })
        }
      }

      return undefined
    },

    loadPortfolio () {
      if (this.loadedPortfolio) {
        this.$store.dispatch('updatePortfolio', this.loadedPortfolio)
      } else {
        const portfolioId = this.getPortfolioIdFromAddressBar()

        if (portfolioId) {
          this.fetchAndUpdatePortfolio(portfolioId)
        }
      }
    },

    fetchAndUpdatePortfolio (id) {
      this.busy = true
      setTimeout(() => {
        this.$http.get(`/${this.$i18n.locale}/portfolios/${id}`)
          .then(response => {
            this.$store.dispatch('updatePortfolio', response.data)
          })
          .finally(() => (this.busy = false))
      }, 200)
    }
  }
}
</script>
