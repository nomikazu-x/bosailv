<template>
  <div>
    <h1 class="main-heading my-8 text-center">メールアドレス変更</h1>
    <TwoColumnContainer
      :left-cols="12"
      :left-sm="4"
      :right-cols="12"
      :right-sm="8"
    >
      <template #left>
        <div class="mb-4">
          <SettingsIndexCard />
        </div>
      </template>

      <template #right>
        <div class="mb-4">
          <SettingsEmailCard
            :user="user"
            :loading="loading"
            :processing="processing"
            :alert="alert"
            :notice="notice"
            @user-update="onUserUpdate"
          />
        </div>
      </template>
    </TwoColumnContainer>
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
