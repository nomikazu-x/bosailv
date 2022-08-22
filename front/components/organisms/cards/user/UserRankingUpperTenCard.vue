<template>
  <BaseTitleCard v-if="users != null && users.length > 0" class="pb-1 px-1" title="ポイントランキング">
    <UserRankingListItem
      v-for="(user, i) in users.slice(0, 10)"
      :key="user.id"
      :user="user"
      :index="i"
    />
    <GreenBtn
      large
      class="my-3"
      outlined
      block
      to="/users/ranking"
    >
      ランキングをもっと見る
    </GreenBtn>
  </BaseTitleCard>
</template>

<script>
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import UserRankingListItem from '~/components/organisms/items/UserRankingListItem.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'UserRankingUpperTenCard',

  components: {
    BaseTitleCard,
    UserRankingListItem,
    GreenBtn
  },

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
  }
}
</script>
