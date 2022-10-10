<template>
  <BaseTitleCard title="アカウント削除" max-width="640px">
    <TheProcessing v-if="processing" />
    <v-card-title>退会前にご確認ください。</v-card-title>
    <v-card-text>
      メールアドレスや、プロフィールを変更したい場合は、下記のメニューから変更できます。退会の手続きは必要ありません。引き続きBosaiLvをお楽しみください。
      <v-list>
        <v-list-item to="/settings/profile">
          <v-list-item-icon>
            <v-icon>mdi-account-edit</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>プロフィール編集</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item to="/settings/password">
          <v-list-item-icon>
            <v-icon>mdi-lock</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>パスワード変更</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item to="/settings/email">
          <v-list-item-icon>
            <v-icon>mdi-email</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>メールアドレス変更</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-card-text>

    <v-card-text class="red--text">
      ※BosaiLvを退会すると、これまでに登録したデータなどが失われ、元に戻すことはできません。
    </v-card-text>

    <div class="text-center">
      <DeleteConfirmDialog title="アカウント削除" name="退会する" @click="onUserDeactivate" />
    </div>
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
