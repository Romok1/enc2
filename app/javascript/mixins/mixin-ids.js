export default {
  methods: {
    getComponentId () {
      return `${this.$options._componentTag}-${this._uid}`
    },
    getUniqueVForKey (elementName, index) {
      return `${this.getComponentId()}-${elementName}-${index}`
    }
  }
}