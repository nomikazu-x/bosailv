<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <UserNameTextField
          v-model="name"
        />
        <OrangeBtn
          id="user_update_btn"
          :disabled="invalid || processing || waiting"
          @click="onUserUpdate()"
        >
          変更
        </OrangeBtn>
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
      name: ''
    }
  },

  created () {
    this.name = this.name || this.user.name
    this.processing = false
  },

  methods: {
    async onUserUpdate () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userUpdateUrl, {
        name: this.name
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
