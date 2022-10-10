<template>
  <div>
    <BaseTitleCard v-if="user != null" :title="cardTitle" />
    <div>
      <div v-if="canAction" cols="12" class="text-right">
        <OrangeBtn class="mt-2 mr-4" to="/articles/new">記事を作成する</OrangeBtn>
      </div>
      <GenreImageListCard class="mt-2" />
      <GreenBtn
        large
        class="mt-6 mb-2"
        outlined
        block
        :to="`/users/${$route.params.username}/articles`"
      >
        すべてのマイ記事を見る
      </GreenBtn>
    </div>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import GenreImageListCard from '~/components/organisms/cards/genre/GenreImageListCard.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'UserShowCardWithGenre',

  components: {
    BaseTitleCard,
    GenreImageListCard,
    OrangeBtn,
    GreenBtn
  },

  mixins: [Application],

  data () {
    return {
      user: null
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
    },
    currentName () {
      return (this.user && this.user.name) || this.$auth.user.name
    },
    cardTitle () {
      return (this.canAction ? 'あなた' : this.currentName) + 'の災害時役立つ記事'
    }
  },
  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/home' })
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
        return this.$router.push({ path: '/home' })
      })

    this.processing = false
  }
}
</script>
