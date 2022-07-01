<template>
  <div v-if="!loading">
    <div v-if="$auth.loggedIn" class="mb-4">
      <UserIntroCard
        :user="$auth.user"
        :required-point="$auth.user.required_point"
      />
    </div>
    <div v-else class="mb-4">
      <SignUp />
    </div>
    <div class="mb-4">
      <ImportantInfomationLists />
    </div>
    <div class="mb-4">
      <ArticlesRankingCard />
    </div>
    <div class="mb-4">
      <UserRankingCard />
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index',
  props: {
    loading: {
      type: Boolean,
      default: false
    }
  }
}
</script>
