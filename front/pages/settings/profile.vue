<template>
  <SettingsProfileTemplate
    :user="user"
    :loading="loading"
    @alert="alert = $event"
    @notice="notice = $event"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersEdit',
  mixins: [Application],

  data () {
    return {
      user: null
    }
  },

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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
        }
      },
      (error) => {
        if (error.response == null) {
          this.$toasted.error(this.$t('network.failure'))
        } else if (error.response.status === 401) {
          return this.signOut()
        } else {
          this.$toasted.error(this.$t('network.error'))
        }
        return this.$router.push({ path: '/' })
      })

    this.loading = false
  }
}
</script>
