<template>
  <UsernameTemplate
    :can-action="canAction"
    :current-username="currentUsername"
    :user="user"
    :articles="articles"
    :required-point="requiredPoint"
    :processing="processing"
    :loading="loading"
    :alert="alert"
    :notice="notice"
  />
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersId',
  mixins: [Application],

  data () {
    return {
      user: null,
      articles: null,
      requiredPoint: 0
    }
  },
  computed: {
    authUsername () {
      return this.$auth.user.username
    },
    canAction () {
      return this.$auth.loggedIn
        ? this.currentUsername === this.authUsername
        : false
    },
    currentUsername () {
      return this.$route.params.username
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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.userGenreArticlesUrl.replace('_username', this.currentUsername).replace('_id', this.$route.params.id))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
          this.articles = response.data.user.articles
          this.requiredPoint = response.data.required_point
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

    this.processing = false
    this.loading = false
  }
}
</script>
