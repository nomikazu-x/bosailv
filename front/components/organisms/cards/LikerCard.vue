<template>
  <BaseTitleCard title="いいねしたユーザー">
    <LikerListItem
      v-for="(liker, i) in likers"
      :key="liker.id"
      :liker="liker"
      :index="i"
    />
  </BaseTitleCard>
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
