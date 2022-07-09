export default (target, ev, handler) => {
  return {
    mounted () {
      if (typeof target === 'string') {
        target = document.querySelectorAll(target)
      }
      if (target instanceof NodeList) {
        target.forEach(el => el.addEventListener(ev, handler.bind(this)))
      } else {
        target.addEventListener(ev, handler.bind(this))
      }
    },
    beforeDestroy() {
      if (typeof target === 'string') {
        target = document.querySelectorAll(target)
      }
      if (target instanceof NodeList) {
        target.forEach(el => el.removeEventListener(ev, handler.bind(this)))
      } else {
        target.removeEventListener(ev, handler.bind(this))
      }
    },
  }
}