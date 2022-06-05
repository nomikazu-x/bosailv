<template>
  <div>
    <p v-if="!lists">災害時役立つは存在しません。作成してください</p>

    <v-list>
      <v-list-item-group>
        <template v-for="(item, key) in lists">
          <ArticleListItem
            :id="item.id"
            :key="key"
            :can-action="true"
            :title="item.title"
          />
        </template>

        <CreateArticleListItem v-if="isCreatingNewArticle" v-model="newFolderName" @submit="onCreateFolder" />
      </v-list-item-group>
    </v-list>
  </div>
</template>

<script>
export default {
  props: {
    currentUserId: {
      type: Number,
      default: null
    },
    lists: {
      type: Array,
      default: () => []
    },
    isCreatingNewArticle: {
      type: Boolean,
      default: false
    }
  }
}
</script>
