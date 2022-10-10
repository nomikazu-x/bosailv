<template>
  <BaseListItem :to="`/users/${liker.username}`">
    <v-list-item-avatar>
      <v-img :src="liker.image_url.mini" />
    </v-list-item-avatar>
    <v-list-item-title class="px-2">
      {{ liker.name }}
    </v-list-item-title>
  </BaseListItem>
</template>

<script>
import BaseListItem from '~/components/molecules/items/BaseListItem.vue'

export default {
  name: 'ArticleLikerListItem',

  components: {
    BaseListItem
  },

  props: {
    liker: {
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
