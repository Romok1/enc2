import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import Vue2TouchEvents from 'vue2-touch-events'
import VueAnalytics from 'vue-analytics'

Vue.use(TurbolinksAdapter)
Vue.use(Vue2TouchEvents)

if (window.ENABLE_ANALYTICS) {
  Vue.use(VueAnalytics, {
    id: 'UA-134550212-1',
    checkDuplicatedScript: true
  })
}

import AgricultureDashboard from '~/components/dashboard/biodiversity-goals/agriculture/Dashboard'
import AuthenticationPopup from '~/components/authentication/AuthenticationPopup'
import CardHolder from '~/components/card/CardHolder'
import Cards from '~/components/portfolios/Cards'
import Carousel from '~/components/carousel/Carousel'
import ExpandableItem from '~/common/ExpandableItem'
import ExploreTool from '~/ExploreTool'
import ExploreWidget from '~/components/explore-widget/ExploreWidget'
import FeedbackForm from '~/components/feedback/FeedbackForm'
import FeedbackPopup from '~/components/feedback/FeedbackPopup'
import FilterPane from '~/components/filters/FilterPane'
import ForgottenPasswordForm from '~/components/authentication/ForgottenPasswordForm'
import I18n from '~/common/translator/I18n'
import IconLock from '~/icons/IconLock'
import IconTick from '~/icons/IconTick'
import LinkTiles from '~/components/link-tiles/LinkTiles'
import ListBox from '~/common/ListBox'
import LocalisedLink from '~/common/translator/LocalisedLink'
import LoginForm from '~/components/authentication/LoginForm'
import MapDisclaimer from '~/components/map/MapDisclaimer'
import MapExplore from '~/components/map/Map'
import MapPage from '~/MapPage'
import MiningDashboard from '~/components/dashboard/biodiversity-goals/mining/Dashboard'
import NaturalCapitalDashboard from '~/components/dashboard/natural-capital/Dashboard'
import NewPasswordForm from '~/components/authentication/NewPasswordForm'
import PopUp from '~/common/PopUp'
import PortfolioGeneratorModal from '~/components/dashboard/biodiversity-goals/portfolio-generators/Modal'
import PortfoliosList from '~/components/portfolios/PortfoliosList'
import ProductionProcesses from '~/components/ProductionProcesses'
import ResendConfirmationForm from '~/components/authentication/ResendConfirmationForm'
import ResourcesViewer from '~/components/resources-viewer/ResourcesViewer'
import Store from '~/components/store/Store'
import SuccessFeedback from '~/components/SuccessFeedback'
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'
import Tooltip from '~/components/tooltip/Tooltip'
import UserAccountManagementPopup from '~/components/authentication/UserAccountManagementPopup'
import UserForm from '~/components/authentication/UserForm'
import VCheckbox from '~/components/form/VCheckbox'
import VMultiselectSearchable from '~/components/v-select/VMultiselectSearchable'
import VNav from '~/common/nav/VNav'
import VPasswordInput from '~/components/form/VPasswordInput'
import VSelectSearchable from '~/components/v-select/VSelectSearchable'

import store from '~/store/store.js'
import axios from '../utilities/axios'

import VueI18n from 'vue-i18n'
Vue.use(VueI18n)

import PortalVue from 'portal-vue'
Vue.use(PortalVue)

Vue.prototype.$http = axios

import { url as localiseUrl } from '~/helpers/localisation-helpers'
Vue.prototype.$url = localiseUrl

import VFocus from '~/vue-plugins/VFocus'
Vue.use(VFocus)

import Qs from 'qs'
Vue.prototype.$qs = function (params, options = {}) {
  return Qs.stringify(params, { arrayFormat: 'brackets', encode: false, ...options })
}

document.addEventListener('turbolinks:load', event => {
  //gtag defined in _google_analytics.html.erb
  if (typeof gtag === 'function') {
    // eslint-disable-next-line no-undef
    gtag('event', 'page_view', {
      page_location: event.data.url,
    })
  }

  window.app = new Vue({
    el: '#v-app',

    components: {
      AgricultureDashboard,
      AuthenticationPopup,
      CardHolder,
      Cards,
      Carousel,
      ExpandableItem,
      ExploreTool,
      ExploreWidget,
      FeedbackForm,
      FeedbackPopup,
      FilterPane,
      ForgottenPasswordForm,
      I18n,
      IconLock,
      IconTick,
      LinkTiles,
      ListBox,
      LocalisedLink,
      LoginForm,
      MapDisclaimer,
      MapExplore,
      MapPage,
      MiningDashboard,
      NaturalCapitalDashboard,
      NewPasswordForm,
      PopUp,
      PortfolioGeneratorModal,
      PortfoliosList,
      ProductionProcesses,
      ResendConfirmationForm,
      ResourcesViewer,
      Store,
      SuccessFeedback,
      Tab,
      Tabs,
      Tooltip,
      UserAccountManagementPopup,
      UserForm,
      VCheckbox,
      VMultiselectSearchable,
      VNav,
      VPasswordInput,
      VSelectSearchable
    },

    i18n: new VueI18n({ silentTranslationWarn: true }),

    store,

    created () {
      this.$store.dispatch('biodiversityGoals/reset')
    }
  })
})
