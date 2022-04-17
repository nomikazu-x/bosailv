<template>
  <div>
    <Loading v-if="loading" />
    <v-card v-if="!loading" max-width="640px">
      <Processing v-if="processing" />
      <v-card-title>アカウント削除</v-card-title>
      <v-card-text>
        <v-dialog transition="dialog-top-transition" max-width="600px">
          <template #activator="{ on, attrs }">
            <v-btn id="user_delete_btn" color="error" :disabled="processing" v-bind="attrs" v-on="on">削除</v-btn>
          </template>
          <template #default="dialog">
            <v-card id="user_delete_dialog">
              <v-toolbar color="error" dark>アカウント削除</v-toolbar>
              <v-card-text>
                <div class="text-h6 pa-6">本当に削除しますか？</div>
              </v-card-text>
              <v-card-actions class="justify-end">
                <v-btn id="user_delete_no_btn" color="secondary" @click="dialog.value = false">いいえ</v-btn>
                <v-btn id="user_delete_yes_btn" color="error" @click="dialog.value = false; onUserDelete()">はい</v-btn>
              </v-card-actions>
            </v-card>
          </template>
        </v-dialog>
      </v-card-text>
      <v-divider />
      <v-card-actions>
        <ul class="my-2">
          <li><NuxtLink to="/users/edit">登録情報変更</NuxtLink></li>
        </ul>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'UsersDelete',
  mixins: [Application],

  async created () {
    try {
      await this.$auth.fetchUser()
    } catch (error) {
      if (error.response == null) {
        this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
      } else if (error.response.status === 401) {
        return this.signOut()
      } else {
        this.$toasted.error('通信エラーが発生しました。しばらく時間をあけてから、やり直してください。')
      }
      return this.$router.push({ path: '/' })
    }

    if (!this.$auth.loggedIn) {
      return this.redirectAuth()
    }

    this.processing = false
    this.loading = false
  },

  methods: {
    async onUserDelete () {
      this.processing = true

      await this.$axios.post('/users/auth/delete.json')
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error('エラーが発生しました。しばらく時間をあけてから、やり直してください。')
          } else {
            return this.signOut(null, '/users/sign_in', response.data.alert, response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error('通信エラーが発生しました。しばらく時間をあけてから、やり直してください。')
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
