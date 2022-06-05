<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading">
      <v-row>
        <v-col cols="auto">
          <UserEmailForm
            :user="user"
            :processing="processing"
            :alert="alert"
            :notice="notice"
            @user-update="onUserUpdate"
          />
        </v-col>
      </v-row>
    </v-card>
  </div>
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
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  methods: {
    onUserUpdate (value) {
      this.$emit('user-update', value)
    }
  }
}
</script>
