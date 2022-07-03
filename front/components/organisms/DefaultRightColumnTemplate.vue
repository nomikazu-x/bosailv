<template>
  <div>
    <div v-if="$auth.loggedIn" class="mb-4">
      <AuthUserIntroCard />
    </div>
    <div v-else class="mb-4">
      <SignUp />
    </div>
    <div class="mb-4">
      <ImportantInfomationListCard />
    </div>
    <div class="mb-4">
      <ArticleRankingUpperFiveCard />
    </div>
    <div class="mb-4">
      <UserRankingUpperTenCard />
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index'
}
</script>
