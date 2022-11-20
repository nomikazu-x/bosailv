<template>
  <v-row v-if="!$auth.loggedIn" justify="center">
    <v-col cols="12" sm="10">
      <BaseTitleCard title="パスワードをリセットする">
        <div class="pa-5">
          <h2 class="mb-3 text-center">メールアドレスを入力</h2>

          <v-row justify="center">
            <v-col cols="12" sm="8">
              <PasswordResetForm
                :processing="processing"
                :errors="errors"
                @password-new="onPasswordNew"
              />
            </v-col>

            <v-col cols="12" sm="12" md="9" class="text-right">
              <v-divider class="mb-2" />

              <UsersActionLink action="password" />
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
import PasswordResetForm from '~/components/organisms/form/PasswordResetForm.vue'
import UsersActionLink from '~/components/molecules/links/UsersActionLink.vue'

export default {
  name: 'PasswordResetCard',

  components: {
    BaseTitleCard,
    PasswordResetForm,
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
    async onPasswordNew (value) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.passwordNewUrl, {
        email: value,
        redirect_url: this.$config.frontBaseURL + this.$config.passwordRedirectUrl
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
