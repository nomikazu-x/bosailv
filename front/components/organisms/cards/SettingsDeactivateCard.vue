<template>
  <v-card max-width="640px">
    <Processing v-if="processing" />
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
              <v-btn id="user_delete_yes_btn" color="error" @click="dialog.value = false; onUserDelete()">はい</v-btn>
            </v-card-actions>
          </v-card>
        </template>
      </v-dialog>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    loading: {
      type: Boolean,
      default: false
    },
    processing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onUserDelete () {
      this.$emit('user-delete')
    }
  }
}
</script>
