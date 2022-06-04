<template>
  <div>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />
    <v-card v-if="!loading">
      <v-row>
        <v-col cols="auto">
          <UserImageFileInput
            :alert="alert"
            :notice="notice"
            :processing="processing"
            @user-image-update="onUserImageUpdate"
            @user-image-delete="onUserImageDelete"
          />
        </v-col>
        <v-col cols="12">
          <UserProfileForm
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
    },
    onUserImageUpdate (image) {
      this.$emit('user-image-update', image)
    },
    onUserImageDelete () {
      this.$emit('user-image-delete')
    }
  }
}
</script>
