<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="12" sm="12">
        <h1 class="mb-8 text-center">ログイン</h1>

        <v-row justify="center">
          <v-col cols="12" sm="10" md="8">
            <ValidationObserver v-slot="{ invalid }" ref="observer">
              <Message :alert="alert" :notice="notice" />
              <v-card class="pa-6">
                <h2 class="mb-3 text-center">App</h2>

                <v-row justify="center">
                  <v-col cols="12" sm="8" md="6">
                    <v-form>
                      <ValidationProvider v-slot="{ errors }" name="email" rules="required|email">
                        <v-text-field
                          v-model="email"
                          label="メールアドレス"
                          prepend-icon="mdi-email"
                          :error-messages="errors"
                        />
                      </ValidationProvider>
                      <ValidationProvider v-slot="{ errors }" name="password" rules="required|min:8">
                        <v-text-field
                          v-model="password"
                          type="password"
                          label="パスワード [8文字以上]"
                          prepend-icon="mdi-lock"
                          append-icon="mdi-eye-off"
                          :error-messages="errors"
                        />
                      </ValidationProvider>

                      <div class="text-center mt-4">
                        <v-btn
                          color="yellow lighten-3"
                          class="btn"
                          :disabled="invalid"
                          @click="signIn"
                        >
                          ログイン
                        </v-btn>
                      </div>
                    </v-form>
                  </v-col>

                  <v-col cols="12" sm="12" md="9" class="text-right">
                    <v-divider class="mb-2" />

                    <ul class="list-style-none pl-0">
                      <li class="mb-1"><NuxtLink to="/password/reset">パスワードをリセット</NuxtLink></li>
                      <li class="mb-1"><NuxtLink to="/signup">新規登録へ</NuxtLink></li>
                    </ul>
                  </v-col>
                </v-row>
              </v-card>
            </ValidationObserver>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { required, email } from 'vee-validate/dist/rules'
import { extend, ValidationObserver, ValidationProvider, setInteractionMode } from 'vee-validate'
import Message from '~/components/Message.vue'
setInteractionMode('eager')
extend('required', {
  ...required,
  message: '入力してください。'
})
extend('email', {
  ...email,
  message: '形式が正しくありません。'
})
export default {
  name: 'UsersSignIn',
  components: {
    ValidationObserver,
    ValidationProvider,
    Message
  },
  data () {
    return {
      alert: null,
      notice: null,
      email: '',
      password: ''
    }
  },
  created () {
    if (this.$auth.loggedIn) {
      this.$toasted.info('既にログインしています。')
      return this.$router.push({ path: '/' })
    }
    if (this.$route.query.alert !== null || this.$route.query.notice !== null) {
      this.alert = this.$route.query.alert
      this.notice = this.$route.query.notice
      return this.$router.push({ path: '/signin' }) // URLパラメータを消す為
    }
  },
  methods: {
    async signIn () {
      await this.$auth.loginWith('local', {
        data: {
          email: this.email,
          password: this.password
        }
      })
        .then((response) => {
          this.$toasted.error(response.data.alert)
          this.$toasted.info(response.data.notice)
          return this.$router.push({ path: '/' })
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
          }
          return error
        })
    }
  }
}
</script>


<style lang="scss" scoped>
.list-style-none {
  list-style: none;
}
</style>
