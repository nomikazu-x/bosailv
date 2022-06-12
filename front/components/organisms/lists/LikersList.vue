<template>
  <v-card>
    <v-card-title>いいねしたユーザー</v-card-title>
    <LikersListItem
      v-for="(liker, i) in likers"
      :key="liker.id"
      :liker="liker"
      :index="i"
    />
  </v-card>
</template>

<script>
export default {
  props: {
    likers: {
      type: Array,
      default: () => []
    }
  }
}
</script>
