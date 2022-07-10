<template>
  <v-row justify="center">
    <v-col cols="12" sm="8">
      <BaseTitleCard title="新しいパスワードを入力してください">
        <div class="pa-5">
          <PasswordResetConfirmForm
            :processing="processing"
            :errors="errors"
            @password-update="onPasswordUpdate"
          />
        </div>
      </BaseTitleCard>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import PasswordResetConfirmForm from '~/components/organisms/form/PasswordResetConfirmForm.vue'

export default {
  name: 'PasswordResetConfirmCard',

  components: {
    BaseTitleCard,
    PasswordResetConfirmForm
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
    async onPasswordUpdate (userInfo) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.passwordUpdateUrl, {
        password: userInfo.password,
        password_confirmation: userInfo.password_confirmation,
        reset_password_token: this.$route.query.reset_password_token
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
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else if (error.response.data.errors == null) {
            return this.$router.push({ path: '/password/reset/confirm', query: { alert: error.response.data.alert, notice: error.response.data.notice } })
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
