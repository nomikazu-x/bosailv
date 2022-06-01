<template>
  <SigninTemplate
    :errors="errors"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
    @signin="onSignIn"
  />
</template>

<script>
import SigninTemplate from '~/components/templates/SigninTemplate'
import Application from '~/plugins/application.js'

export default {
  name: 'UsersSignin',
  components: {
    SigninTemplate
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
    async onSignIn (userInfo) {
      this.processing = true

      await this.$auth.loginWith('local', {
        data: {
          email: userInfo.email,
          password: userInfo.password
        }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
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
