<template>
  <div>
    <BaseListItem :to="`/users/${user.username}`">
      <v-list-item-avatar>
        <v-img :src="user.image_url.mini" />
      </v-list-item-avatar>
      <v-list-item-title class="pl-2">
        {{ user.name }}
      </v-list-item-title>
    </BaseListItem>
    <v-divider />
  </div>
</template>

<script>
import BaseListItem from '~/components/molecules/items/BaseListItem.vue'

export default {
  name: 'UserRankingListItem',

  components: {
    BaseListItem
  },

  props: {
    user: {
      type: Object,
      required: true
    },
    index: {
      type: Number,
      required: true
    }
  }
}
</script>
