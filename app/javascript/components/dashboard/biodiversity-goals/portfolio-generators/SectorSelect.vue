<template>
  <div class="sector-select">
    <h2 class="sector-select__title">
      {{ t.title }}
    </h2>
    <ul class="sector-select__items">
      <li
        v-for="sector in sectors"
        :key="sector.id"
        class="sector-select__item"
      >
        <div class="sector-select__radio-group">
          <input
            :id="sector.id"
            :checked="isSelected(sector.id)"
            :value="sector.id"
            type="radio"
            class="sector-select__radio"
            @change="$emit('change', sector.id)"
          >
          <label
            :for="sector.id"
            class="sector-select__label"
          >
            <component
              :is="`icon-${sector.id}`"
              class="sector-select__icon"
            />
            {{ sector.title }}
          </label>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import IconAgriculture from '~/icons/IconAgriculture'
import IconMining from '~/icons/IconMining'

export default {
  components: {
    IconAgriculture,
    IconMining
  },

  model: {
    event: 'change',
    prop: 'selectedSector'
  },

  props: {
    selectedSector: {
      type: String,
      default: undefined
    },
    sectors: {
      type: Array,
      required: true
    }
  },

  computed: {
    t () {
      return this.$t('biodiversity_goals.landing.modal.sector_select')
    }
  },

  methods: {
    isSelected (sector) {
      return this.selectedSector === sector
    }
  }
}
</script>
