<template>
  <BaseTitleCard v-if="users != null && users.length > 0" class="pb-1 px-1" title="ポイントランキング">
    <UserRankingItem
      v-for="(user, i) in users.slice(0, 9)"
      :key="user.id"
      :user="user"
      :index="i"
    />
    <RedBtn
      large
      class="my-3"
      outlined
      block
      to="/users/ranking"
    >
      ランキングをもっと見る
    </RedBtn>
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
