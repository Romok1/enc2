
import Vue from 'vue/dist/vue.esm'

export default class ErrorBag {
  constructor (errors) {
    this.set(errors)
  }

  set (errors) {
    Vue.set(this, 'errors', errors)
  }

  add (field, errors) {
    errors = Array.isArray(errors) ? errors : [errors]
    if (Object.prototype.hasOwnProperty.call(this.errors, field)) {
      Vue.set(this.errors, field, [...this.errors[field], ...errors])
    } else {
      Vue.set(this.errors, field, errors)
    }
  }

  any (field) {
    return this.has(field)
  }

  clear (field) {
    if (this.errors) {
      Vue.delete(this.errors, field)
    }
  }

  count (field) {
    if (this.errors) {
      if (field) {
        return Object.prototype.hasOwnProperty.call(this.errors, field)
          ? this.errors[field].length
          : 0
      }

      return Object.values(this.errors).reduce((count, errorsArray) => count + errorsArray.length, 0)
    }

    return 0
  }

  first (field) {
    return this.has(field) ? this.get(field)[0] : undefined
  }

  get (field) {
    if (field) {
      if (this.has(field)) {
        return [...new Set(this.errors[field])]
      }

      return []
    }

    return Object.values(this.errors).flatMap(errors => [...new Set(errors)])
  }

  has (field) {
    return this.count(field) > 0
  }

  reset () {
    this.set(undefined)
  }

  keys () {
    return Object.keys(this.errors)
  }
}
