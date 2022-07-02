<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <div class="mb-4">
        <UserIntroCard
          :user="user"
          :required-point="requiredPoint"
        />
      </div>
    </template>

    <template v-if="!loading" #right>
      <BaseTitleCard :title="cardTitle">
        <div class="pa-5">
          <v-row>
            <v-col v-if="canAction" cols="12" class="text-right">
              <RedBtn class="my-b mr-4" to="/articles/new">記事を作成する</RedBtn>
            </v-col>
          </v-row>

          <GenreImageCard :genres="genres" />
        </div>
      </BaseTitleCard>
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersUsername',
  mixins: [Application],

  data () {
    return {
      user: null,
      genres: null,
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

    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.currentUsername))
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
        } else {
          this.user = response.data.user
          this.genres = response.data.genres
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
