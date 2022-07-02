<template>
  <OneColumnContainer>
    <h1 class="main-heading mb-8 text-center">BosaiLevel</h1>

    <TheLoading v-if="loading" />
    <TheMessage v-if="!loading" :alert="alert" :notice="notice" />

    <v-row v-if="!loading" justify="center">
      <v-col cols="12" sm="10" md="8">
        <SignupCard
          :processing="processing"
          :errors="errors"
          @signup="onSignUp"
        />
      </v-col>
    </v-row>
  </OneColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'

export default {
  name: 'SignUpIndex',
  mixins: [Application],
  data () {
    return {
      errors: null
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
    async onSignUp (userInfo) {
      this.processing = true
      await this.$axios.post(this.$config.apiBaseURL + this.$config.singUpUrl, {
        name: userInfo.name,
        email: userInfo.email,
        password: userInfo.password,
        password_confirmation: userInfo.password_confirmation,
        confirm_success_url: this.$config.frontBaseURL + this.$config.singUpSuccessUrl
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
