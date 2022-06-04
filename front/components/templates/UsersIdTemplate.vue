<template>
  <div>
    <TwoColumnContainer
      :left-cols="12"
      :left-sm="4"
      :right-cols="12"
      :right-sm="8"
    >
      <template #left>
        <div class="mb-4 mt-10">
          <UserIntroCard
            :user="user"
          />
        </div>
      </template>

      <template #right>
        <div class="mb-4">
          <SettingsProfileCard
            :user="user"
            :loading="loading"
            :processing="processing"
            :alert="alert"
            :notice="notice"
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
  }
}
</script>
