<template>
  <BaseTitleCard title="アカウント削除" max-width="640px">
    <TheProcessing v-if="processing" />
    <v-card-text>
      <v-dialog transition="dialog-top-transition" max-width="600px">
        <template #activator="{ on, attrs }">
          <v-btn id="user_delete_btn" color="error" :disabled="processing" v-bind="attrs" v-on="on">削除</v-btn>
        </template>
        <template #default="dialog">
          <v-card id="user_delete_dialog">
            <v-toolbar color="error" dark>アカウント削除</v-toolbar>
            <v-card-text>
              <div class="text-h6 pa-6">本当に削除しますか？</div>
            </v-card-text>
            <v-card-actions class="justify-end">
              <v-btn id="user_delete_no_btn" color="secondary" @click="dialog.value = false">いいえ</v-btn>
              <v-btn id="user_delete_yes_btn" color="error" @click="dialog.value = false; onUserDeactivate()">はい</v-btn>
            </v-card-actions>
          </v-card>
        </template>
      </v-dialog>
    </v-card-text>
  </BaseTitleCard>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseTitleCard from '~/components/molecules/cards/BaseTitleCard.vue'

export default {
  name: 'SettingsDeactivateCard',

  components: {
    BaseTitleCard
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
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
