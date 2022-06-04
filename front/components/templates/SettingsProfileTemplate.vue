<template>
  <div>
    <h1 class="main-heading my-8 text-center">プロフィール設定</h1>
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
          <SettingsProfileCard
            :user="user"
            :loading="loading"
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
