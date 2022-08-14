<template>
  <BaseTitleCard title="アカウント削除" max-width="640px">
    <TheProcessing v-if="processing" />
    <DeleteConfirmDialog title="アカウント削除" @click="onUserDeactivate" />
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'SettingsDeactivateCard',

  components: {
    BaseTitleCard,
    DeleteConfirmDialog
  },

  mixins: [Application],

  created () {
    this.processing = false
  },

  methods: {
    async onUserDeactivate () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userDeactivateUrl)
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            return this.signOut(null, '/signin', response.data.alert, response.data.notice)
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
            this.$toasted.error(error.response.data.alert)
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
