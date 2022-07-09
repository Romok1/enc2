import ErrorBag from '~/classes/ErrorBagV2'
import MultiErrorBag from '~/classes/MultiErrorBag'
import {
  BAD_REQUEST,
  UNPROCESSABLE_ENTITY,
} from '~/helpers/http-status-codes'

export default {
  data () {
    return {
      baseErrors: new ErrorBag(),
      formErrors: new MultiErrorBag(),
      busy: true,
      countries: undefined,
    }
  },

  computed: {
    forms () {
      return this.$store.state.biodiversityGoals.portfolioGenerator.forms
    },

    anyErrors () {
      return this.baseErrors.any() || this.formErrors.any()
    },

    portfolio () {
      return this.$store.state.portfolio
    },
  },

  created () {
    this.$http.get(`/${this.$i18n.locale}${this.countriesEndpoint}`).then(response => {
      this.countries = response.data.map(country => ({ id: country.iso_3, name: country.name }))
      this.busy = false
    })
      .catch(() => this.setErrors({ base: [this.$t('errors.messages.unknown')] }))
  },

  methods: {
    onError (e) {
      const { forms, ...baseErrors } = e.response.data.errors

      switch (e.response.status) {
      case BAD_REQUEST:
      case UNPROCESSABLE_ENTITY:
        this.baseErrors.set(baseErrors)
        if (forms) {
          this.formErrors.set(forms)
          Object.keys(forms).forEach(index => {
            this.$set(this.forms[index], '$_active', true)
          })
        }
        break
      default:
        this.baseErrors.set({ base: [this.$t('errors.messages.unknown')] })
      }
      this.$emit('errors', this.errors)
    },

    onAddButtonClick () {
      this.addForm()
      this.toggleActive(this.forms[this.forms.length - 1])
    },

    onFormChange ({ form, index }) {
      const forms = [ ...this.forms ]

      forms[index] = form

      this.$store.dispatch('biodiversityGoals/portfolioGenerator/updateForms', forms)
    },

    onFormDelete (formIndex) {
      this.$delete(this.forms, formIndex)
      this.formErrors.index(formIndex).reset()

      if (this.forms.length === 0) {
        this.addForm()
      }
    },

    onSubmit () {
      this.validate().then(() => {
        window.open(this.endpoint, '_self')
      })
    },

    toggleActive (form) {
      this.forms.forEach((_, index) => this.$set(this.forms[index], '$_active', false))
      this.$set(form, '$_active', true)
    },

    validate () {
      return new Promise((resolve) => {
        this.busy = true

        this.baseErrors.reset()
        this.formErrors.reset()

        setTimeout(() => {
          this.$http.get(this.validationEndpoint)
            .then(resolve)
            .catch(this.onError)
            .finally(() => (this.busy = false))
        }, 200)
      })
    },

    generateEndpoint (path) {
      return `${path}?${this.queryString}`
    }
  }
}