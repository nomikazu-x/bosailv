<template>
  <BaseTitleCard class="pb-1 px-1" title="ポイントランキング">
    <UserRankingItem
      v-for="(user, i) in users.slice(0, 9)"
      :key="user.id"
      :user="user"
      :index="i"
    />
    <v-btn
      large
      class="my-3"
      color="#ef5350"
      outlined
      block
      to="/users/ranking"
    >
      ランキングをもっと見る
    </v-btn>
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
