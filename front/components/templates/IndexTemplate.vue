<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #left>
      <div v-if="!$auth.loggedIn" class="mb-4 mt-10">
        <SignUp />
      </div>
    </template>

    <template #right>
      <div v-if="$auth.loggedIn" class="mb-4 mt-10">
        <UserIntroCard
          :user="$auth.user"
          :required-point="$auth.user.required_point"
        />
      </div>
      <div v-else class="mb-4 mt-10">
        <SignUp />
      </div>
      <div class="mb-4 mt-10">
        <ImportantInfomationLists
          :infomations="infomations"
        />
      </div>
      <div class="mb-4 mt-10">
        <UserRankingCard
          :users="users"
        />
      </div>
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    canAction: {
      type: Boolean,
      default: false
    },
    user: {
      type: Object,
      default: null
    },
    users: {
      type: Array,
      default: () => []
    },
    infomations: {
      type: Array,
      default: () => []
    },
    requiredPoint: {
      type: Number,
      default: 0
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
