export function id (property) {
  return `form-${this.index}__${property}`
}

export function onCloseButtonClick () {
  this.$emit('delete')
}

export function onUpdate (property, value) {
  this.update(property, value)
  this.errors.clear(property)
}

export function update (property, value) {
  this.$emit('change', {
    ...this.form,
    [property]: value
  })
}
