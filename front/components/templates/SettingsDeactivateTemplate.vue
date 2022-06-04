<template>
  <div>
    <h1 class="main-heading my-8 text-center">アカウント削除</h1>
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
          <SettingsDeactivateCard
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
    },
    processing: {
      type: Boolean,
      default: false
    }
  }
}
</script>
