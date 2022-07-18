<template>
  <span>
    <TheProcessing v-if="processing" />
    <OrangeBtn v-if="isCompleted" large @click="onUnComplete">
      完了!
    </OrangeBtn>
    <GreenBtn v-else large @click="onComplete">
      未完了
    </GreenBtn>
  </span>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'FavoriteBtnGroup',
  components: {
    OrangeBtn,
    GreenBtn
  },
  mixins: [Application],
  props: {
    task: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      isCompleted: this.task.is_completed
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onComplete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.completeCreateUrl.replace('_id', this.$route.params.id), {
        user_id: this.$auth.user.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setPoint', response.data.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_point, { root: true })
            this.isCompleted = true
            this.$toasted.info(response.data.notice)
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

    async onUnComplete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.completeDeleteUrl.replace('_id', this.$route.params.id), {
        user_id: this.$auth.user.id
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else if (this.$auth.loggedIn) {
            this.$store.commit('user/setPoint', response.data.user, { root: true })
            this.$store.commit('user/setRequiredPoint', response.data.required_point, { root: true })
            this.isCompleted = false
            this.$toasted.info(response.data.notice)
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
