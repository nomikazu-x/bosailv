<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="新規登録">
        <div class="pa-5">
          <v-row justify="center">
            <v-col cols="12" sm="8" md="6">
              <SignupForm
                :processing="processing"
                :errors="errors"
                @sign-up="onSignUp"
              />
            </v-col>

            <v-col cols="12" sm="12" md="9" class="text-right">
              <v-divider class="mb-2" />

              <UsersActionLink action="sign_up" />
            </v-col>
          </v-row>
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import SignupForm from '~/components/organisms/form/SignupForm.vue'
import UsersActionLink from '~/components/molecules/links/UsersActionLink.vue'

export default {
  name: 'SignupCard',

  components: {
    BaseTitleCard,
    SignupForm,
    UsersActionLink
  },

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
            this.$emit('alert', error.response.data.alert)
            this.$emit('notice', error.response.data.notice)
          }
        })
      this.processing = false
    }
  }
}
</script>

<style lang="scss" scoped>
.other-heading {
  font-size: 1rem;
  font-weight: normal;
  margin-bottom: 0.5rem;
}
</style>
