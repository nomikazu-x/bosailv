<template>
  <BaseTitleCard v-if="user != null" title="メールアドレス変更">
    <v-row>
      <v-col cols="auto">
        <UserEmailForm
          :user="user"
          :processing="processing"
          @user-update="onUserUpdate"
        />
      </v-col>
    </v-row>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'SettingsEmailCard',
  mixins: [Application],

  data () {
    return {
      user: null
    }
  },

  async created () {
    await this.$axios.get(this.$config.apiBaseURL + this.$config.userShowUrl.replace('_username', this.$auth.user.username))
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

    this.processing = false
  },
  methods: {
    async onUserUpdate (userInfo) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userUpdateUrl, {
        email: userInfo.email,
        current_password: userInfo.current_password,
        confirm_redirect_url: this.$config.frontBaseURL + this.$config.confirmationSuccessUrl
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$auth.setUser(response.data.user)
            if (this.$auth.loggedIn) {
              return this.redirectSuccess(response.data.alert, response.data.notice)
            } else {
              return this.redirectSignIn(response.data.alert, response.data.notice)
            }
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
          }
        })

      this.processing = false
    }
  }
}
</script>
