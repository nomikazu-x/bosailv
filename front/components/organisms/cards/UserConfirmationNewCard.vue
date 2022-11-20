<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="メールアドレス確認">
        <div class="pa-5">
          <v-row justify="center">
            <v-col cols="12" sm="8" md="6">
              <UserConfirmationNewForm
                :processing="processing"
                :errors="errors"
                @confirmation-new="onConfirmationNew"
              />
            </v-col>

            <v-col cols="12" sm="12" md="9" class="text-right">
              <v-divider class="mb-2" />

              <UsersActionLink action="confirmation" />
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
import UserConfirmationNewForm from '~/components/organisms/form/UserConfirmationNewForm.vue'
import UsersActionLink from '~/components/molecules/links/UsersActionLink.vue'

export default {
  name: 'UserConfirmationNewCard',

  components: {
    BaseTitleCard,
    UserConfirmationNewForm,
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
    async onConfirmationNew (userInfo) {
      this.processing = true
      await this.$axios.post(this.$config.apiBaseURL + this.$config.confirmationNewUrl, {
        email: userInfo.email,
        redirect_url: this.$config.frontBaseURL + this.$config.confirmationSuccessUrl
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            return this.redirectSuccess(response.data.alert, response.data.notice)
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
