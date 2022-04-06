<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="12" sm="12">
        <h1 class="mb-8 text-center">新規登録</h1>

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
                          @click="signUp"
                        >
                          新規登録
                        </v-btn>
                      </div>
                    </v-form>
                  </v-col>

                  <v-col cols="12" sm="12" md="9" class="text-right">
                    <v-divider class="mb-2" />

                    <ul class="list-style-none pl-0">
                      <li class="mb-1"><NuxtLink to="/password/reset">パスワードをリセット</NuxtLink></li>
                      <li class="mb-1"><NuxtLink to="/signin">ログインへ</NuxtLink></li>
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
import { required, email, min, confirmed } from 'vee-validate/dist/rules'
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
extend('min', {
  ...min,
  message: '{length}文字以上で入力してください。'
})
extend('confirmed', {
  ...confirmed,
  message: 'パスワードと一致しません。'
})
export default {
  name: 'UsersSignUp',
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
  },
  methods: {
    async signUp () {
      await this.$axios.post('/api/v1/auth', {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.password_confirmation,
        confirm_success_url: '/users/sign_in'
      })
        .then((response) => {
          return this.$router.push({ path: '/users/sign_in', query: { alert: response.data.alert, notice: response.data.notice } })
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
            this.$refs.observer.setErrors(error.response.data.errors)
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