<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <BaseTitleCard v-if="!loading" title="ポイントランキング">
        <UserRankingItem
          v-for="(user, i) in users"
          :key="user.id"
          :user="user"
          :index="i"
        />
      </BaseTitleCard>
    </template>

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    users: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: false
    },
    processing: {
      type: Boolean,
      default: false
    },
    alert: {
      type: Boolean,
      default: false
    },
    notice: {
      type: Boolean,
      default: false
    }
  }
}
</script>
