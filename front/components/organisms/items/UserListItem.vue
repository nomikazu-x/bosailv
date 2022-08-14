<template>
  <v-row justify="center" align="center">
    <v-col cols="9">
      <BaseListItem :to="`/users/${user.username}`">
        <v-list-item-avatar>
          <v-img :src="user.image_url.mini" />
        </v-list-item-avatar>
        <v-list-item-title class="pl-2">
          {{ user.name }}
        </v-list-item-title>
      </BaseListItem>
    </v-col>
    <v-col cols="3">
      <DeleteConfirmDialog title="ユーザー削除" @click="onUserDelete(user.id)" />
    </v-col>
    <v-divider />
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import BaseListItem from '~/components/molecules/items/BaseListItem.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'UserListItem',

  components: {
    BaseListItem,
    DeleteConfirmDialog
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

      await this.$axios.post(this.$config.apiBaseURL + this.$config.adminUserDeleteUrl.replace('_username', this.user.username))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$store.commit('user/deleteUser', userId, { root: true })
            this.$toasted.error(response.data.alert)
            this.$toasted.success(response.data.notice)
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
            this.$toasted.success(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
