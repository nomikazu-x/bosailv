<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="ログイン">
        <div class="pa-5">
          <v-row justify="center">
            <v-col cols="12" sm="8" md="6">
              <SigninForm
                :processing="processing"
                :errors="errors"
                @sign-in="onSignIn"
              />
            </v-col>

            <v-col cols="12" sm="12" md="9" class="text-right">
              <v-divider class="mb-2" />

              <ul class="list-style-none pl-0">
                <li class="mb-1"><NuxtLink to="/password/reset">パスワードをリセット</NuxtLink></li>
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
  name: 'SigninCard',
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
    async onSignIn (userInfo) {
      this.processing = true

      await this.$auth.loginWith('local', {
        data: {
          email: userInfo.email,
          password: userInfo.password
        }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
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
