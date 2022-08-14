<template>
  <div>
    <TheProcessing v-if="processing" />
    <GreenBtn
      v-if="isConfirmed"
      large
      disabled
    >
      ハザードマップ確認済みです。
    </GreenBtn>
    <OrangeBtn
      v-else
      large
      :disabled="processing"
      @click="onHazardMapConfirm"
    >
      ハザードマップ確認した!
    </OrangeBtn>
  </div>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'HazardMapConfirmBtn',

  components: {
    OrangeBtn,
    GreenBtn
  },

  mixins: [Application],

  data () {
    return {
      isConfirmed: this.$auth.user.is_hazard_map_confirmed
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onHazardMapConfirm () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.taskProfileUpdateUrl, {
        hazard_map_confirmed: true
      })
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/setLevel', response.data.user.level, { root: true })
            this.$auth.setUser(response.data.user)
            this.isConfirmed = true
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
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
