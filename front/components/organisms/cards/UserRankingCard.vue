<template>
  <v-card>
    <v-card-title>
      <v-icon color="#ffc400">
        mdi-trophy
      </v-icon>
      <span class="pl-1">獲得経験値ランキング</span>
    </v-card-title>
    <UserRankingItem
      v-for="(user, i) in users"
      :key="user.id"
      :user="user"
      :index="i"
    />
  </v-card>
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
