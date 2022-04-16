<template>
  <v-container>
    <Message :alert="alert" :notice="notice" />
    <v-row justify="center">
      <v-col cols="12" md="12">
        <h1 class="main-heading mb-8 text-center">プロフィール編集</h1>

        <v-row justify="center">
          <v-col cols="12" sm="10" md="8">
            <ValidationObserver v-slot="{ invalid }" ref="observer">
              <v-card class="pt-10 px-6 pb-8">
                <v-form autocomplete="off">
                  <div class="mb-8">
                    <p>プロフィール画像</p>
                    <v-avatar color="primary" size="40" />
                  </div>

                  <v-card-text>
                    <ValidationProvider v-slot="{ errors }" name="name" rules="required">
                      <v-text-field
                        v-model="name"
                        label="氏名"
                        prepend-icon="mdi-account"
                        autocomplete="off"
                        :error-messages="errors"
                        class="mb-8"
                        @click="waiting = false"
                      />
                    </ValidationProvider>
                    <ValidationProvider v-slot="{ errors }" name="username">
                      <v-text-field
                        v-model="username"
                        label="ユーザー名"
                        prepend-icon="mdi-account"
                        autocomplete="off"
                        :error-messages="errors"
                        class="mb-8"
                        @click="waiting = false"
                      />
                    </ValidationProvider>
                    <ValidationProvider v-slot="{ errors }" name="address">
                      <v-text-field
                        v-model="address"
                        label="出身"
                        prepend-icon="mdi-account"
                        autocomplete="off"
                        :error-messages="errors"
                        placeholder="例) 東京"
                        class="mb-8"
                        @click="waiting = false"
                      />
                    </ValidationProvider>
                    <ValidationProvider v-slot="{ errors }" name="profile">
                      <v-textarea
                        v-model="profile"
                        label="プロフィール"
                        prepend-icon="mdi-account"
                        autocomplete="off"
                        :error-messages="errors"
                        outlined
                        class="mb-8"
                        @click="waiting = false"
                      />
                    </ValidationProvider>
                  </v-card-text>

                  <div class="d-flex justify-center mt-5">
                    <v-btn color="primary" :disabled="invalid || waiting" @click="userUpdate">保存する</v-btn>
                  </div>
                </v-form>
              </v-card>
            </ValidationObserver>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { required, email, min } from 'vee-validate/dist/rules'
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
export default {
  name: 'UsersSignUp',
  components: {
    ValidationObserver,
    ValidationProvider,
    Message
  },
  data () {
    return {
      waiting: false,
      alert: null,
      notice: null,
      user: null,
      name: '',
      username: '',
      address: '',
      profile: ''
    }
  },
  created () {
    if (!this.$auth.loggedIn) {
      this.$toasted.info('ログインしてください。')
      return this.$auth.redirect('login') // Tips: ログイン後、元のページに戻す
    }
    this.$axios.get(`/api/v1/users/${this.$auth.user.data.id}`)
      .then((response) => {
        console.log(response)
        this.user = response.data.data.user
        this.name = response.data.data.attributes.name
        this.username = response.data.data.attributes.username
        this.profile = response.data.data.attributes.profile
        this.address = response.data.data.attributes.address
      },
      (error) => {
        if (error.response.status === 401) {
          this.signOut()
          return this.$auth.redirect('login') // Tips: ログイン後、元のページに戻す
        }
        this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
        return this.$router.push({ path: '/' })
      })
  },
  methods: {
    async signOut () {
      await this.$auth.logout()
      this.$toasted.info('ログインしてください。')
      // Devise Token Auth
      if (localStorage.getItem('token-type') === 'Bearer' && localStorage.getItem('access-token')) {
        localStorage.removeItem('token-type')
        localStorage.removeItem('uid')
        localStorage.removeItem('client')
        localStorage.removeItem('access-token')
        localStorage.removeItem('expiry')
      }
    },
    async userUpdate () {
      await this.$axios.put('api/v1/auth', {
        name: this.name,
        username: this.username,
        address: this.address,
        profile: this.profile
      })
        .then((response) => {
          this.$auth.setUser(response.data.user)
          this.$toasted.error(response.data.alert)
          this.$toasted.info(response.data.notice)
          return this.$router.push({ path: '/' })
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
          } else if (error.response.data != null) {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
            if (error.response.data.errors != null) { this.$refs.observer.setErrors(error.response.data.errors) }
          }
          return error
        })
    }
  }
}
</script>
