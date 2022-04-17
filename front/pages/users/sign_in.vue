<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading" max-width="480px">
      <Processing v-if="processing" />
      <validation-observer v-slot="{ invalid }">
        <v-form autocomplete="on">
          <v-card-title>ログイン</v-card-title>
          <v-card-text>
            <validation-provider v-slot="{ errors }" name="email" rules="required|email">
              <v-text-field
                v-model="email"
                label="メールアドレス"
                prepend-icon="mdi-email"
                autocomplete="email"
                :error-messages="errors"
                @click="waiting = false"
              />
            </validation-provider>
            <validation-provider v-slot="{ errors }" name="password" rules="required">
              <v-text-field
                v-model="password"
                type="password"
                label="パスワード"
                prepend-icon="mdi-lock"
                append-icon="mdi-eye-off"
                autocomplete="current-password"
                :error-messages="errors"
                @click="waiting = false"
              />
            </validation-provider>
            <v-btn id="sign_in_btn" color="primary" :disabled="invalid || processing || waiting" @click="onSignIn()">ログイン</v-btn>
          </v-card-text>
          <v-divider />
          <v-card-actions>
            <ActionLink action="sign_in" />
          </v-card-actions>
        </v-form>
      </validation-observer>
    </v-card>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend } from 'vee-validate'
import { required, email } from 'vee-validate/dist/rules'
import ActionLink from '~/components/users/ActionLink.vue'
import Application from '~/plugins/application.js'

extend('required', { ...required, message: '入力してください。' })
extend('email', { ...email, message: '形式が正しくありません。' })

export default {
  name: 'UsersSignIn',
  components: {
    ValidationObserver,
    ValidationProvider,
    ActionLink
  },
  mixins: [Application],

  data () {
    return {
      waiting: false,
      email: '',
      password: ''
    }
  },

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }
    this.setQueryMessage()
    this.processing = false
    this.loading = false
  },

  methods: {
    async onSignIn () {
      this.processing = true

      await this.$auth.loginWith('local', {
        data: {
          email: this.email,
          password: this.password
        }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error('エラーが発生しました。しばらく時間をあけてから、やり直してください。')
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error('通信に失敗しました。しばらく時間をあけてから、やり直してください。')
          } else if (error.response.data == null) {
            this.$toasted.error('通信エラーが発生しました。しばらく時間をあけてから、やり直してください。')
          } else {
            this.alert = error.response.data.alert
            this.notice = error.response.data.notice
            this.waiting = true
          }
        })

      this.processing = false
    }
  }
}
</script>
