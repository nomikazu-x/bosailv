<template>
  <div v-if="!loading">
    <div v-if="$auth.loggedIn" class="mb-4">
      <UserIntroCard
        :user="$auth.user"
        :required-point="$auth.user.required_point"
      />
    </div>
    <div v-else class="mb-4">
      <SignUp />
    </div>
    <div class="mb-4">
      <ImportantInfomationLists :infomations="infomations" />
    </div>
    <div class="mb-4">
      <ArticlesRankingCard :famous-articles="famousArticles" />
    </div>
    <div class="mb-4">
      <UserRankingCard :users="users" />
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index',
  props: {
    loading: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      genres: null,
      famousArticles: null,
      users: null,
      infomations: null
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.genresUrl)
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          this.genres = null
        } else {
          this.genres = response.data.genres
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
      })

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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.usersUrl)
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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.articlesUrl, {
      params: { famous: true }
    })
      .then((response) => {
        if (response.data == null || response.data.article == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.famousArticles = response.data.articles
        }
      },
      (error) => {
        this.$toasted.error(this.$t(error.response == null ? 'network.failure' : 'network.error'))
        return this.$router.push({ path: '/' })
      })
  }
}
</script>
