<template>
  <v-row justify="center" align="center">
    <v-col cols="10">
      <BaseListItem :to="`/users/${user.username}`">
        <v-list-item-avatar>
          <v-img :src="user.image_url.mini" />
        </v-list-item-avatar>
        <v-list-item-title class="pl-2">
          {{ user.name }}
        </v-list-item-title>
      </BaseListItem>
    </v-col>
    <v-col cols="2">
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
                <v-btn id="user_delete_yes_btn" color="error" @click="dialog.value = false; onUserDelete(user.id)">はい</v-btn>
              </v-card-actions>
            </v-card>
          </template>
        </v-dialog>
      </v-card-text>
    </v-col>
    <v-divider />
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseListItem from '~/components/molecules/items/BaseListItem.vue'

export default {
  name: 'UserListItem',

  components: {
    BaseListItem
  },

  mixins: [Application],

  props: {
    user: {
      type: Object,
      required: true
    },
    index: {
      type: Number,
      required: true
    }
  },

  created () {
    this.processing = false
  },

  methods: {
    async onUserDelete (userId) {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.userDeleteUrl.replace('_username', this.user.username))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/deleteUser', userId, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            return this.$router.push({ path: '/admin' })
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
