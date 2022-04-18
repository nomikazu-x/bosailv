<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
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
        <ValidationProvider v-slot="{ errors }" name="password" rules="min:8">
          <v-text-field
            v-model="password"
            type="password"
            label="パスワード [8文字以上] (変更する場合のみ)"
            prepend-icon="mdi-lock"
            append-icon="mdi-eye-off"
            autocomplete="new-password"
            :error-messages="errors"
            @click="waiting = false"
          />
        </ValidationProvider>
        <ValidationProvider v-slot="{ errors }" name="password_confirmation" rules="confirmed_password:password">
          <v-text-field
            v-model="password_confirmation"
            type="password"
            label="パスワード(確認) (変更する場合のみ)"
            prepend-icon="mdi-lock"
            append-icon="mdi-eye-off"
            autocomplete="new-password"
            :error-messages="errors"
            @click="waiting = false"
          />
        </ValidationProvider>
        <ValidationProvider v-slot="{ errors }" name="current_password" rules="required">
          <v-text-field
            v-model="current_password"
            type="password"
            label="現在のパスワード"
            prepend-icon="mdi-lock"
            append-icon="mdi-eye-off"
            autocomplete="off"
            :error-messages="errors"
            @click="waiting = false"
          />
        </ValidationProvider>
        <v-btn id="user_update_btn" color="primary" :disabled="invalid || processing || waiting" @click="onUserUpdate()">変更</v-btn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'InfoEdit',

  mixins: [Application],

  props: {
    user: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      waiting: false,
      name: '',
      email: '',
      password: '',
      password_confirmation: '',
      current_password: ''
    }
  },

  created () {
    this.name = this.name || this.user.name
    this.email = this.email || this.user.email
    this.processing = false
  },

  methods: {
    async onUserUpdate () {
      this.processing = true

      await this.$axios.post('/users/auth/update.json', {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.password_confirmation,
        current_password: this.current_password
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
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
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
