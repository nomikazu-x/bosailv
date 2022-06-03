<template>
  <PasswordResetConfirmTemplate
    :errors="errors"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @submit="onPasswordUpdate"
  />
</template>

<script>
import PasswordResetConfirmTemplate from '~/components/templates/PasswordResetConfirmTemplate'
import Application from '~/plugins/application.js'

export default {
  name: 'UsersPasswordReset',
  components: {
    PasswordResetConfirmTemplate
  },
  mixins: [Application],
  data () {
    return {
      errors: null
    }
  },
  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    if (this.$route.query.reset_password === 'false') {
      return this.$router.push({ path: '/password/reset', query: { alert: this.$route.query.alert, notice: this.$route.query.notice } })
    }
    if (this.$route.query.reset_password_token) {
      return this.$router.push({ path: '/password/reset', query: { alert: this.$t('auth.reset_password_token_blank') } })
    }
    this.processing = false
    this.loading = false
  },
  methods: {
    async onPasswordUpdate (userInfo) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.passwordUpdateUrl, {
        password: userInfo.password,
        password_confirmation: userInfo.password_confirmation,
        reset_password_token: this.$route.query.reset_password_token
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.setUser(response.data.user)
            if (this.$auth.loggedIn) {
              return this.redirectSuccess(response.data.alert, response.data.notice)
            } else {
              return this.redirectSignIn(response.data.alert, response.data.notice)
            }
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else if (error.response.data.errors == null) {
            return this.$router.push({ path: '/password/reset/confirm', query: { alert: error.response.data.alert, notice: error.response.data.notice } })
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
          }
        })
      this.processing = false
    }
  }
}
</script>
