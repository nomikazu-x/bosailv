<template>
  <v-card>
    <v-row>
      <v-col cols="auto">
        <UserImageFileInput
          :processing="processing"
          @user-image-update="onUserImageUpdate"
          @user-image-delete="onUserImageDelete"
        />
      </v-col>
      <v-col cols="12">
        <UserProfileForm
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
