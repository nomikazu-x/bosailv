<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <h1 class="main-heading my-8 text-center">プロフィール設定</h1>
      <Loading v-if="loading" />
      <Message v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <div class="mb-4">
        <SettingsIndexCard />
      </div>
    </template>

    <template v-if="!loading" #right>
      <div class="mb-4">
        <SettingsProfileCard
          :user="user"
          :processing="processing"
          @user-update="onUserUpdate"
          @user-image-update="onUserImageUpdate"
          @user-image-delete="onUserImageDelete"
        />
      </div>
    </template>
  </TwoColumnContainer>
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
