<template>
  <UsersIdTemplate
    :can-action="canAction"
    :current-user-id="currentUserId"
    :user="user"
    :lists="lists"
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
      lists: null,
      requiredPoint: 0
    }
  },
  computed: {
    authUserId () {
      return this.$auth.user.id
    },
    canAction () {
      return this.$auth.loggedIn
        ? this.currentUserId === this.authUserId
        : false
    },
    currentUserId () {
      return Number(this.$route.params.id)
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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl, {
      user_id: this.currentUserId
    })
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
          this.lists = response.data.user.articles
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
