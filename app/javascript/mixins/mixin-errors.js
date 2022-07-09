import VErrors from '~/components/form/VErrors'

export const addErrors = function (field, errors) {
  this.$set(this.$_errors, field, Array.isArray(errors) ? errors : [errors])
}

export const anyErrors = function (field) {
  return this.hasErrors(field)
}

export const clearErrors = function (field) {
  if (this.$_errors) {
    this.$delete(this.$_errors, field)
  }
}

export const countErrors = function (field) {
  if (this.$_errors) {
    if (field) {
      return this.$_errors.hasOwnProperty(field) ? this.$_errors[field].length : 0
    }

    return Object.values(this.$_errors).reduce((carr, curr) => carr + curr.length, 0)
  }

  return 0
}

export const firstError = function (field) {
  return this.hasErrors(field) ? this.getErrors(field)[0] : undefined
}

export const getErrors = function (field) {
  if (this.hasErrors(field)) {
    return this.$_errors[field]
  }

  return []
}

export const hasErrors = function (field) {
  return this.countErrors(field) > 0
}

export const setErrors = function (errors) {
  this.$_errors = errors ? errors : {}
}

export default {
  components: {
    VErrors,
  },

  data () {
    return {
      $_errors: {}
    }
  },

  methods: {
    addErrors,
    anyErrors,
    clearErrors,
    countErrors,
    firstError,
    getErrors,
    hasErrors,
    setErrors
  }
}
