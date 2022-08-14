<template>
  <div>
    <TheProcessing v-if="processing" />
    <RedBtn
      id="guest_sign_in_btn"
      :disabled="processing"
      @click="onGuestSignIn"
    >
      ゲストログイン
    </RedBtn>
    <div class="text-caption mt-2 grey--text" style="text-align: left">
      ※こちらはメールアドレス、パスワードを入力せず、ご利用いただけます。
    </div>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'GuestSigninBtn',

  components: {
    RedBtn
  },

  mixins: [Application],

  created () {
    this.processing = false
  },

  methods: {
    async onGuestSignIn () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.guestSignInUrl)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.setUser(response.data.user)
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            this.$router.push({ path: '/' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
