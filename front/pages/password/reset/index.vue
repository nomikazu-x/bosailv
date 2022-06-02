<template>
  <PasswordResetTemplate
    :errors="errors"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @submit="onPasswordNew"
  />
</template>

<script>
import PasswordResetTemplate from '~/components/templates/PasswordResetTemplate'
import Application from '~/plugins/application.js'

export default {
  name: 'UsersPasswordReset',
  components: {
    PasswordResetTemplate
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
    this.processing = false
    this.loading = false
  },
  methods: {
    async onPasswordNew (email) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.passwordNewUrl, {
        email,
        redirect_url: this.$config.frontBaseURL + this.$config.passwordRedirectUrl
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
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
