<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading">
      <v-card-title>
        <v-icon color="#ffc400">
          mdi-trophy
        </v-icon>
        <span class="pl-1">獲得経験値ランキング</span>
      </v-card-title>
      <RankingUserCard
        v-for="(user, i) in users"
        :key="user.id"
        :user="user"
        :index="i"
      />
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersIndex',
  mixins: [Application],
  data () {
    return {
      users: null
    }
  },
  async created () {
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

    this.loading = false
  }
}
</script>
