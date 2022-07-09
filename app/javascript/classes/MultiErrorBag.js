
import Vue from 'vue/dist/vue.esm'
import ErrorBag from '~/classes/ErrorBagV2'

export default class MultiErrorBag {
  constructor (errors) {
    this.set(errors)

  }

  set (errors) {
    if (errors) {
      Vue.set(
        this,
        'errors',
        Object.keys(errors).reduce((obj, key) => {
          obj[key] = new ErrorBag(errors[key])

          return obj
        }, {})
      )
    } else {
      Vue.set(this, 'errors', {})
    }
  }

  any () {
    return this.count() > 0
  }

  clear (index) {
    if (this.errors) {
      Vue.delete(this.errors, index)
    }
  }

  count () {
    if (this.errors) {
      return Object.values(this.errors).reduce((count, errorBag) => count + errorBag.count(), 0)
    }

    return 0
  }

  reset () {
    this.set(undefined)
  }

  keys () {
    return Object.keys(this.errors)
  }

  index (index) {
    if (Object.prototype.hasOwnProperty.call(this.errors, index)) {
      return this.errors[index]
    }

    return new ErrorBag()
  }
}
