<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading" max-width="850px">
      <v-card-title>登録情報変更</v-card-title>
      <v-row>
        <v-col cols="auto" md="4">
          <ImageEdit @alert="alert = $event" @notice="notice = $event" />
        </v-col>
        <v-col cols="12" md="8">
          <InfoEdit :user="user" @alert="alert = $event" @notice="notice = $event" />
        </v-col>
      </v-row>
      <v-divider />
      <v-card-actions>
        <ul class="my-2">
          <li><NuxtLink to="/users/delete">アカウント削除</NuxtLink></li>
        </ul>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import ImageEdit from '~/components/users/edit/ImageEdit.vue'
import InfoEdit from '~/components/users/edit/InfoEdit.vue'

export default {
  name: 'UsersEdit',
  components: {
    ImageEdit,
    InfoEdit
  },
  mixins: [Application],

  data () {
    return {
      user: null
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

    await this.$axios.get('/users/auth/show.json')
      .then((response) => {
        if (response.data == null) {
          this.$toasted.error(this.$t('system.error'))
          return this.$router.push({ path: '/' })
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
        return this.$router.push({ path: '/' })
      })

    this.loading = false
  }
}
</script>
