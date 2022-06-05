<template>
  <div>
    <p v-if="lists.length">災害時役立つは存在しません。作成してください</p>

    <v-list>
      <v-list-item-group>
        <template v-for="(item, key) in lists">
          <ArticleListItem
            :id="item.id"
            :key="key"
            :title="item.title"
          />
        </template>
      </v-list-item-group>
    </v-list>
  </div>
</template>

<script>
export default {
  props: {
    lists: {
      type: Array,
      default: () => []
    }
  }
}
</script>
