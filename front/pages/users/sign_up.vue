<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading" max-width="480px">
      <Processing v-if="processing" />
      <ValidationObserver v-slot="{ invalid }" ref="observer">
        <v-form autocomplete="off">
          <v-card-title>アカウント登録</v-card-title>
          <v-card-text>
            <ValidationProvider v-slot="{ errors }" name="name" rules="required">
              <v-text-field
                v-model="name"
                label="氏名"
                prepend-icon="mdi-account"
                autocomplete="off"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <ValidationProvider v-slot="{ errors }" name="email" rules="required|email">
              <v-text-field
                v-model="email"
                label="メールアドレス"
                prepend-icon="mdi-email"
                autocomplete="off"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <ValidationProvider v-slot="{ errors }" name="password" rules="required|min:8">
              <v-text-field
                v-model="password"
                type="password"
                label="パスワード [8文字以上]"
                prepend-icon="mdi-lock"
                append-icon="mdi-eye-off"
                autocomplete="new-password"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <ValidationProvider v-slot="{ errors }" name="password_confirmation" rules="required|confirmed_password:password">
              <v-text-field
                v-model="password_confirmation"
                type="password"
                label="パスワード(確認)"
                prepend-icon="mdi-lock"
                append-icon="mdi-eye-off"
                autocomplete="new-password"
                :error-messages="errors"
                @click="waiting = false"
              />
            </ValidationProvider>
            <v-btn id="sign_up_btn" color="primary" :disabled="invalid || processing || waiting" @click="onSignUp()">登録</v-btn>
          </v-card-text>
          <v-divider />
          <v-card-actions>
            <ActionLink action="sign_up" />
          </v-card-actions>
        </v-form>
      </ValidationObserver>
    </v-card>
  </div>
</template>

<script>
import ActionLink from '~/components/users/ActionLink.vue'
import Application from '~/plugins/application.js'

export default {
  name: 'UsersSignUp',
  components: {
    ActionLink
  },
  mixins: [Application],

  data () {
    return {
      waiting: false,
      name: '',
      email: '',
      password: '',
      password_confirmation: ''
    }
  },

  created () {
    if (this.$auth.loggedIn) {
      return this.redirectAlreadyAuth()
    }

    this.processing = false
    this.loading = false
  },

  methods: {
    async onSignUp () {
      this.processing = true

      await this.$axios.post('/users/auth/sign_up.json', {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.password_confirmation
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
            if (error.response.data.errors != null) {
              this.$refs.observer.setErrors(error.response.data.errors)
              this.waiting = true
            }
          }
        })

      this.processing = false
    }
  }
}
</script>
