<template>
  <v-row v-if="!$auth.loggedIn" justify="center">
    <v-col cols="12" sm="10">
      <BaseTitleCard title="パスワードをリセットする">
        <div class="pa-5">
          <h2 class="mb-3 text-center">メールアドレスを入力</h2>

          <v-row justify="center">
            <v-col cols="12" sm="8">
              <PasswordResetForm
                :processing="processing"
                :errors="errors"
                @submit="onPasswordNew"
              />
            </v-col>

            <v-col cols="12" sm="12">
              <v-divider class="mb-2" />

              <ul class="list-style-none pl-0">
                <li class="mb-1"><NuxtLink to="/signin">ログインへ</NuxtLink></li>
                <li class="mb-1"><NuxtLink to="/signup">新規登録へ</NuxtLink></li>
              </ul>
            </v-col>
          </v-row>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'PasswordResetIndex',
  mixins: [Application],
  data () {
    return {
      errors: null
    }
  },
  created () {
    this.processing = false
  },
  methods: {
    async onPasswordNew (email) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.passwordNewUrl, {
        email,
        redirect_url: this.$config.frontBaseURL + this.$config.passwordRedirectUrl
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
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
