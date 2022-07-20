<template>
  <BaseTitleCard v-if="user != null" :title="cardTitle">
    <div class="pa-5">
      <v-row>
        <v-col v-if="canAction" cols="12" class="text-right">
          <RedBtn class="my-b mr-4" to="/articles/new">記事を作成する</RedBtn>
        </v-col>
      </v-row>

      <GenreImageListCard />
    </div>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import GenreImageListCard from '~/components/organisms/cards/genre/GenreImageListCard.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'UserShowCardWithGenre',

  components: {
    BaseTitleCard,
    GenreImageListCard,
    RedBtn
  },

  mixins: [Application],

  data () {
    return {
      user: null,
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
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
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
  }
}
</script>
