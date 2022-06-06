<template>
  <IndexTemplate
    :users="users"
    :infomations="infomations"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'Index',
  mixins: [Application],
  data () {
    return {
      users: null,
      infomations: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.importantInfomationsUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.infomations = null
        } else {
          this.infomations = response.data.infomations
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })
    await this.$axios.get(this.$config.apiBaseURL + this.$config.usersRankingUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.users = response.data.users
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
