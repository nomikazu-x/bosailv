<template>
  <v-card>
    <v-row>
      <v-col cols="auto">
        <UserEmailForm
          :user="user"
          :processing="processing"
          @user-update="onUserUpdate"
        />
      </v-col>
    </v-row>
  </v-card>
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
