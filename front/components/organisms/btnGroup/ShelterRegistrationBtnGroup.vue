<template>
  <span>
    <TheProcessing v-if="processing" />
    <GreenBtn v-if="isRegistered" @click="onUnRegistration">
      マイ避難所登録を解除する
    </GreenBtn>
    <OrangeBtn v-else @click="onRegistration">
      マイ避難所に登録する
    </OrangeBtn>
  </span>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'ShelterRegistrationBtnGroup',

  components: {
    OrangeBtn,
    GreenBtn
  },

  mixins: [Application],

  props: {
    shelter: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      isRegistered: this.shelter.is_registered
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onRegistration () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.shelterRegistrationCreateUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setLevel', response.data.user.level, { root: true })
            this.$auth.setUser(response.data.user)
            this.isRegistered = true
            this.$toasted.success(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
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
          }
        })

      this.processing = false
    },

    async onUnRegistration () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.shelterRegistrationDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$auth.setUser(response.data.user)
            this.isRegistered = false
            this.$toasted.success(response.data.notice)
          } else {
            return this.redirectSignIn(response.data.alert, response.data.notice)
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
          }
        })

      this.processing = false
    }
  }
}
</script>
