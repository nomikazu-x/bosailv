<template>
  <div>
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
      <ImportantInfomationCard />
    </div>
    <div class="mb-4">
      <ArticleRankingCard />
    </div>
    <div class="mb-4">
      <UserRankingCard />
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index'
}
</script>
