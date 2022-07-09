<template>
  <div
    class="authentication-popup"
    :class="{ 'authentication-popup--registered': registered }"
  >
    <pop-up 
      id="authentication-popup"
      v-model="show"
      @opened="toggleCarousel(true)"
      @closed="resetData"
    >
      <template slot="pop-up">
        <div class="authentication-popup__popup-container">
          <div
            v-if="showCarousel"
            class="authentication-popup__popup-aside"
          >
            <carousel ref="carousel">
              <div
                v-for="(slide, index) in carouselContent"
                :key="index"
                class="carousel__cell"
                :style="slideStyle(slide)"
              >
                <div class="carousel__cell-content">
                  <div class="carousel__cell-heading">
                    {{ slide.heading }}
                  </div>
                  <div 
                    v-if="slide.body"
                    class="carousel__cell-body"
                  >
                    {{ slide.body }}
                  </div>
                </div>
                <div class="carousel__cell-overlay" />
              </div>
            </carousel>
          </div>
          <div class="authentication-popup__popup-body">
            <div class="authentication-popup__popup-tabs">
              <tabs
                id="authentication-popup-tabs"
                class="tabs"
              >
                <tab
                  id="LOGIN"
                  :title="$t('auth.sign_in')"
                >
                  <keep-alive>
                    <login-form
                      @errors="refreshCarousel"
                    />
                  </keep-alive>
                </tab>
                <tab
                  id="REGISTER"
                  :title="$t('auth.sign_up')"
                >
                  <keep-alive>
                    <div
                      v-if="registered"
                      class="register-form__success-page"
                    >
                      <success-feedback>
                        <template v-slot:heading>
                          {{ $t('devise.confirmations.please_verify') }}
                        </template>
                        <template v-slot:body>
                          {{ $t('devise.confirmations.verify_instructions') }}
                        </template>
                      </success-feedback>
                    </div>
                    <user-form
                      v-else
                      @errors="refreshCarousel"
                      @ready="refreshCarousel"
                      @success="onRegistered"
                    />
                  </keep-alive>
                </tab>
              </tabs>
            </div>
          </div>
        </div>
      </template>
    </pop-up>
  </div>
</template>
<script>
import Carousel from '~/components/carousel/Carousel'
import LoginForm from '~/components/authentication/LoginForm'
import PopUp from '~/common/PopUp'
import SuccessFeedback from '~/components/SuccessFeedback'
import Tab from '~/components/tabs/Tab'
import Tabs from '~/components/tabs/Tabs'
import UserForm from '~/components/authentication/UserForm'

export default {
  components: {
    Carousel,
    LoginForm,
    PopUp,
    SuccessFeedback,
    Tab,
    Tabs,
    UserForm,
  },
  props: {
    carouselContent: {
      required: true,
      type: Array,
      validator: items => items.every(slide => typeof slide === 'object')
    }
  },
  data () {
    return {
      show: false,
      showCarousel: true,
      registered: false
    }
  },
  methods: {
    onRegistered () {
      this.registered = true
      this.toggleCarousel(false)
    },

    refreshCarousel () {
      setTimeout(() => {
        this.$root.$emit('refresh-carousel')
      }, 0)
    },

    resetData () {
      this.showCarousel = true
      this.registered = false
    },

    slideStyle (slide) {
      if (slide.background_image) {
        return {
          backgroundImage: 'url(' + slide.background_image + ')'
        }
      }
    },

    toggleCarousel (active) {
      this.showCarousel = active === true
    }
  }
}
</script>