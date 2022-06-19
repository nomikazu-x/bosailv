<template>
  <BaseTitleCard title="ポイントランキング">
    <UserRankingItem
      v-for="(user, i) in users"
      :key="user.id"
      :user="user"
      :index="i"
    />
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    users: {
      type: Array,
      default: () => []
    }
  }
}
</script>
