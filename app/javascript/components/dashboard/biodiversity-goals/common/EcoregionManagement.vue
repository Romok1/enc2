<template>
  <div class="ecoregion-management">
    <h3 class="ecoregion-management__title">
      {{ t.title }}
    </h3>

    <p class="ecoregion-management__intro">
      {{ t.intro }}
    </p>

    <v-table 
      class="ecoregion-management__table"
      :headers="tableHeaders"
      :rows="tableRows"
      :collapse-on-mobile="true"
      :row-limit="0"
    />
  </div>
</template>

<script>
import VTable from '~/components/v-table/VTable'

export default {
  components: { VTable },

  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.shared.components.exposure_results.ecoregion_management')
    },

    ecoregionCategoriesT () {
      return this.$t('biodiversity_goals.dashboard.shared.ecoregion_categories')
    },

    rowTranslations () {
      return this.t.table.ecoregion_management
    },

    tableHeaders () {
      const headers = this.t.table.headers

      return Object.keys(headers).map(headerId => ({
        id: headerId,
        label: headers[headerId]
      }))
    },

    tableRows () {
      return Object.keys(this.rowTranslations).map(categoryId => ({
        ecoregionCategory: this.getCategoryCell(categoryId),
        managementActions: this.getManagementCell(this.rowTranslations[categoryId])
      }))
    }
  },

  methods: {
    getCategoryCell (categoryId) {
      return `<div class="ecoregion-management__cell--category">
        <span class="color-key--${categoryId}"></span>
        ${this.ecoregionCategoriesT[categoryId]}
      </div>`
    },

    getManagementCell (rowTranslation) {
      const listElements = rowTranslation.map(line => `<li>${line}</li>`)

      return `<ul>${listElements.join('')}</ul>`
    }
  }
}
</script>