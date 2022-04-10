<template>
  <div>
    <v-card max-width="640px">
      <v-card-title>
        アカウント削除
      </v-card-title>
      <v-card-text>
        <v-dialog transition="dialog-top-transition" max-width="600px">
          <template #activator="{ on, attrs }">
            <v-btn color="error" v-bind="attrs" v-on="on">
              削除
            </v-btn>
          </template>
          <template #default="dialog">
            <v-card>
              <v-toolbar color="error" dark>
                アカウント削除
              </v-toolbar>
              <v-card-text>
                <div class="text-h6 pa-6">
                  本当に削除しますか？
                </div>
              </v-card-text>
              <v-card-actions class="justify-end">
                <v-btn color="secondary" @click="dialog.value = false">
                  いいえ
                </v-btn>
                <v-btn color="error" @click="dialog.value = false; userDelete()">
                  はい
                </v-btn>
              </v-card-actions>
            </v-card>
          </template>
        </v-dialog>
      </v-card-text>
      <v-card-actions>
        <ul>
          <li>
            <NuxtLink to="/users/edit">
              登録情報変更
            </NuxtLink>
          </li>
        </ul>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  name: 'UsersDelete',
  
  data () {
    return {
      // loading: true,
      // processing: true
    }
  },
  async created () {
    await this.$auth.fetchUser()
    if (!this.$auth.loggedIn) {
      this.$toasted.info('ログインしてください。')
      return this.$auth.redirect('login') // Tips: ログイン後、元のページに戻す
    }
  },
  methods: {
    async signOut (path, query) {
      await this.$auth.logout()
      // Devise Token Auth
      if (localStorage.getItem('token-type') === 'Bearer' && localStorage.getItem('access-token')) {
        localStorage.removeItem('token-type')
        localStorage.removeItem('uid')
        localStorage.removeItem('client')
        localStorage.removeItem('access-token')
        localStorage.removeItem('expiry')
      }
      if (path !== null) {
        return this.$router.push({ path, query })
      }
    },
    userDelete () {
      this.$axios.delete('/api/v1/auth')
        .then((response) => {
          return this.signOut('/signin', { alert: response.data.alert, notice: response.data.notice })
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
            return error
          }
          if (error.response.status === 401) {
            this.$toasted.info('ログインしてください。')
            return this.signOut(null, null)
          }
          if (error.response.data != null) {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          } else {
            this.$toasted.error('通信エラーが発生しました。しばらく時間をあけてから、やり直してください。')
          }
          return error
        })
    }
  }
}
</script>
