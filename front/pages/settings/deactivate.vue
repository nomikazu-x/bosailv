<template>
  <SettingsDeactivateTemplate
    :loading="loading"
    :processing="processing"
    :alert="alert"
    :notice="notice"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersDelete',
  mixins: [Application],

  async created () {
    try {
      await this.$auth.fetchUser()
    } catch (error) {
      if (error.response == null) {
        this.$toasted.error(this.$t('network.failure'))
      } else if (error.response.status === 401) {
        return this.signOut()
      } else {
        this.$toasted.error(this.$t('network.error'))
      }
      return this.$router.push({ path: '/' })
    }

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    this.processing = false
    this.loading = false
  },

  methods: {
    async onUserDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userDeleteUrl)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            return this.signOut(null, '/users/sign_in', response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
