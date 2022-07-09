<template>
  <div class="ecoregion-categories">
    <h3 class="ecoregion-categories__title">
      {{ t.title }}
    </h3>

    <div class="ecoregion-categories__text">
      <p class="ecoregion-categories__intro">
        {{ t.intro }}
      </p>

      <p class="ecoregion-categories__intro">
        <span class="ecoregion-categories__data-source">
          {{ t.data_source }}:
        </span>

        <a 
          href="https://academic.oup.com/bioscience/article/67/6/534/3102935?login=true"
          :title="t.link_title_dinerstein"
          target="_blank"
        >
          {{ t.dinerstein }}
        </a>; 

        <a 
          href="https://conbio.onlinelibrary.wiley.com/doi/full/10.1111/conl.12692"
          :title="t.link_title_beyer"
          target="_blank"
        >
          {{ t.beyer }}
        </a>
      </p>
    </div>

    <div class="ecoregion-categories__diagram-container">
      <div class="ecoregion-categories-diagram" />
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    t () {
      return this.$t('biodiversity_goals.dashboard.shared.components.exposure_results.ecoregion_categories_modal')
    }
  }
}
</script>