<template>
  <dashboard-modal
    v-if="data"
    v-model="active"
  >
    <template slot="header">
      <h3 class="dashboard-modal__title">
        {{ data.mineral }}
      </h3>
    </template>
 
    <template slot="body">
      <p>{{ data.justification }}</p>

      <p v-if="data.references && data.references.length">
        <ul class="ul--unstyled">
          <li 
            v-for="(reference, index) in data.references"
            :key="getUniqueVForKey('reference', index)"
          >
            <a
              :href="reference.url"
              target="_blank"
              class="dashboard-modal__link"
            >
              {{ reference.name }}
            </a>
          </li> 
        </ul>
      </p>
    </template>
  </dashboard-modal>
</template>

<script>
import DashboardModal from '~/components/dashboard/DashboardModal'
import mixinIds from '~/mixins/mixin-ids'

export default {
  components: {
    DashboardModal
  },

  mixins: [mixinIds],

  data () {
    return {
      active: false,
      data: undefined
    }
  },

  created () {
    this.$root.$on('commodity-modal:open', this.onDashboardModalOpen)
  },

  beforeDestroy () {
    this.$root.$off('commodity-modal:open', this.onDashboardModalOpen)
  },

  methods: {
    onDashboardModalOpen (data) {
      this.data = data
      this.$nextTick(() => this.active = true)
    }
  }
}
</script>
