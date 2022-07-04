<template>
  <BaseTitleCard v-if="users != null" title="ポイントランキング">
    <UserRankingListItem
      v-for="(user, i) in users"
      :key="user.id"
      :user="user"
      :index="i"
    />
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UserRankingListCard',
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

    this.processing = false
  }
}
</script>
