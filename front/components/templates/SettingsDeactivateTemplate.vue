<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="4"
    :right-cols="12"
    :right-sm="8"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template v-if="!loading" #left>
      <div class="mb-4">
        <SettingsIndexCard />
      </div>
    </template>

    <template v-if="!loading" #right>
      <div class="mb-4">
        <SettingsDeactivateCard
          :processing="processing"
          @user-delete="onUserDelete"
        />
      </div>
    </template>
  </TwoColumnContainer>
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
  },
  methods: {
    onUserDelete () {
      this.$emit('user-delete')
    }
  }
}
</script>
