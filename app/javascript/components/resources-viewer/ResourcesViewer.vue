<template>
  <div class=" section-padding">
    <div class="resources__filters">
      <v-select-searchable 
        class="resources__filter" 
        :config="entitySelectConfig" 
        :selected="selectedEntity" 
        :options="currentResourcesSet.resources"
        @update:selected-option="updateEntity"
      />

      <v-select-searchable 
        class="resources__filter" 
        :config="regionSelectConfig" 
        :selected="selectedResourcesSet" 
        :options="resourceSets"
        @update:selected-option="updateResourcesSet"
      />
    </div>

    <template v-if="currentResourceFeatures.length">
      <template v-for="feature in currentResourceFeatures">
        <div :key="`resource-viewier-${feature.name.replace(' ', '_')}`">
          <h3 class="list-item list-page__item">
            {{ feature.name }}
          </h3>

          <a
            v-for="dataset in feature.datasets"
            :key="dataset.name"
            :href="dataset.url"
            :title="resources_t.resource_link"
            target="_blank"
            class="list-item list-item--white"
          >
            <span>
              <div class="resources__name paragraph paragraph--no-margin">{{ dataset.name }}</div>
              <div
                v-if="showNotInMapLabel(dataset)"
                class="resources__non-map-label flex-inline flex-v-center"
              >
                <span class="info-icon" />
                <span class="paragraph paragraph--no-margin">{{ resources_t.not_in_map }}</span>
              </div>
            </span>
            <span class="resources__link flex-no-shrink list-item--arrow flex-hs-end">{{ resources_t.resource_link }}</span>
          </a>
        </div>
      </template>
    </template>

    <div 
      v-else
      class="resources__no-datasets list-item list-page__item"
    >
      {{ resources_t.no_datasets }}
    </div>
  </div>
</template>

<script>
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

export default {
  components: {
    VSelectSearchable
  },

  props: {
    resourceSets: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      entitySelectConfig: { id: 'resources-viewer-select-entity' },
      regionSelectConfig: { id: 'resources-viewer-select-region' },
      resources_t: this.$t('resources'),
      selectedEntity: '',
      selectedResourcesSet: ''
    }
  },

  computed: {
    currentResourceFeatures () {
      return this.currentResources.features.filter(this.showFeature)
    },

    currentResources () {
      return this.currentResourcesSet.resources.find(entity => entity.id === this.selectedEntity)
    },

    currentResourcesSet () {
      return this.resourceSets.find(set => set.id === this.selectedResourcesSet)
    }
  },

  created () {
    this.updateResourcesSet(this.resourceSets.find(op => op.id === 'global').id)
    this.updateEntity(this.currentResourcesSet.resources[0].id)
  },

  methods: {
    updateResourcesSet(id) {
      this.selectedResourcesSet = id
    },

    updateEntity(id) {
      this.selectedEntity = id
    },

    showFeature(feature) {
      return Boolean(feature.datasets.length)
    },

    showNotInMapLabel (dataset) {
      return !dataset.on_map
    }
  }
}
</script>
