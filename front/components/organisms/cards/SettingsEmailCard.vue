<template>
  <BaseTitleCard title="メールアドレス変更">
    <v-row>
      <v-col cols="auto">
        <UserEmailForm
          :user="user"
          :processing="processing"
          @user-update="onUserUpdate"
        />
      </v-col>
    </v-row>
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: null
    },
    processing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onUserUpdate (value) {
      this.$emit('user-update', value)
    }
  }
}
</script>
