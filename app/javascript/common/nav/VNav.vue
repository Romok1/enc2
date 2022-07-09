<template>
  <sticky-bar class="sm-trigger-sticky">
    <nav
      aria-label="site-nav"
      class="nav flex flex-v-center flex-h-between sm-target-sticky sticky-bar--unstuck"
    >
      <a
        :href="`/${$i18n.locale}`"
        class="h3"
      >
        <span
          title="ENCORE Home"
          class="encore-logo nav__logo"
        />
        <span
          title="ENCORE Home"
          class="encore-mobile-logo nav__mobile-logo"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 512 512"
          >
            <path d="M406 179.293V51.085h-60v68.457l-90-89.627L0 284.853v31.232h61v166h159.667v-100h70v100H451v-166h61v-31.232z" />
          </svg>
        </span>
      </a>

      <span class="nav__left flex-hs-start">
        <slot name="nav-left" />
      </span>

      <div
        :id="mixinModalId"
        class="nav__item-container flex"
        :class="navType"
      >
        <button
          v-show="isBurgerNav"
          id="close-nav-pane"
          class="button button--plain nav__close icon-close"
          @click="closeNavPane"
        />
        <ul
          role="menubar"
          class="nav__items ul--unstyled flex"
        >
          <li
            v-for="page in pages"
            :key="page.id"
            role="none"
            class="nav__item relative"
          >
            <v-nav-dropdown
              v-if="page.children"
              :item="page"
              :is-burger="isBurgerNav"
            />
            <v-nav-link
              v-else
              :item="page"
            />
          </li>

          <li
            v-if="user"
            role="none"
            class="nav__item relative"
          >
            <v-nav-dropdown
              :item="{
                id: 'my-profile',
                label: user.name ? user.name : $t('navigation.my_account'),
                url: $url('#'),
                children: [
                  {
                    id: 'account-details-via-popup',
                    label: $t('navigation.account_details'),
                    url: $url('#account-management-popup'),
                  },
                  {
                    id: 'sign-out',
                    label: $t('navigation.sign_out'),
                    url: $url('/users/sign_out'),
                    method: 'delete',
                  }
                ],
              }"
              :is-burger="isBurgerNav"
            />
          </li>
          <li
            v-else
            role="none"
            class="nav__item relative"
          >
            <v-nav-link
              :item="{
                id: 'authenticate-via-popup',
                label: $t('navigation.login_signup'),
                url: $url('#authentication-popup'),
              }"
            />
          </li>
        </ul>
      </div>

      <span
        v-if="!isLarge()"
        class="nav__right"
      >
        <slot name="nav-right" />
      </span>

      <button
        v-show="isBurgerNav"
        :id="mixinTriggerId"
        class="button button--plain nav__burger icon-burger"
        @click="openNavPane"
      />
    </nav>
  </sticky-bar>
</template>

<script>
import StickyBar from '~/common/sticky/StickyBar'
import VNavDropdown from './VNavDropdown'
import VNavLink from './VNavLink'
import { mixinResponsive } from '~/mixins/mixin-responsive'
import mixinPopupCloseListeners from '~/mixins/mixin-popup-close-listeners'
import mixinFocusCapture from '~/mixins/mixin-focus-capture'
import { disableTabbing, reenableTabbing } from '~/helpers/focus-helpers'

export default {
  components: {
    StickyBar,
    VNavDropdown,
    VNavLink,
  },

  mixins: [
    mixinResponsive,
    mixinPopupCloseListeners({closeCallback: 'closeNavPane', toggleVariable: 'isNavPaneActive'}),
    mixinFocusCapture({toggleVariable: 'isNavPaneActive', closeCallback: 'closeNavPane', openCallback: 'openNavPane'})
  ],

  props: {
    pages: {
      required: true,
      type: Array
    },
    isAlwaysBurger: {
      default: false,
      type: Boolean
    }
  },

  data () {
    return {
      isNavPaneActiveData: false,
      selectedDropdownId: null,
      mixinModalId: 'nav-pane',
      mixinTriggerId: 'open-nav-pane'
    }
  },

  computed: {
    user () {
      return this.$store.state.user
    },

    isBurgerNav() {
      return this.isAlwaysBurger || !this.isLarge()
    },

    navType() {
      return {
        'nav--pane': this.isBurgerNav,
        'nav--bar': !this.isBurgerNav,
        'nav-pane--active': this.isNavPaneActive
      }
    },

    navPaneItemContainer() {
      return this.$el.querySelector('.nav__item-container')
    },

    isNavPaneActive () {
      return this.isNavPaneActiveData && this.isBurgerNav
    },

    areNavPaneItemsVisible () {
      return !this.isBurgerNav || this.isNavPaneActive
    }
  },

  watch: {
    areNavPaneItemsVisible (visible) {
      visible ? reenableTabbing(this.navPaneItemContainer) : disableTabbing(this.navPaneItemContainer)
    }
  },

  mounted () {
    this.areNavPaneItemsVisible ? reenableTabbing(this.navPaneItemContainer) : disableTabbing(this.navPaneItemContainer)
  },

  methods: {
    openNavPane() {
      this.isNavPaneActiveData = true
    },

    closeNavPane() {
      this.isNavPaneActiveData = false
    }
  }
}
</script>
