<template>
  <v-row justify="center">
    <v-col cols="12" sm="10" md="10">
      <BaseTitleCard title="ログイン">
        <div class="pa-5">
          <v-row justify="center">
            <v-col cols="12" sm="8" md="6">
              <SigninForm
                :processing="processing"
                :errors="errors"
                @sign-in="onSignIn"
              />
            </v-col>

            <v-col cols="12" sm="12" md="9" class="text-right">
              <v-divider class="mb-2" />

              <UsersActionLink action="sign_in" />
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
import SigninForm from '~/components/organisms/form/SigninForm.vue'
import UsersActionLink from '~/components/molecules/links/UsersActionLink.vue'

export default {
  name: 'SigninCard',

  components: {
    BaseTitleCard,
    SigninForm,
    UsersActionLink
  },

  mixins: [Application],

  data () {
    return {
      errors: null
    }
  },

  computed: {
    authRedirectPath () {
      return (this.$auth.user.prefecture == null && this.$auth.user.city == null) ? { path: '/settings/profile' } : { path: '/home' }
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onSignIn (userInfo) {
      this.processing = true

      await this.$auth.loginWith('local', {
        data: {
          email: userInfo.email,
          password: userInfo.password,
          unlock_redirect_url: this.$config.frontBaseURL + this.$config.unlockRedirectUrl
        }
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
            this.$router.push(this.authRedirectPath)
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
