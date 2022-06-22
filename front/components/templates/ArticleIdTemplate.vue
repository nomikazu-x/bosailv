<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <Loading v-if="loading" />
      <Message v-if="!loading" :alert="alert" :notice="notice" />
    </template>

    <template #left>
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <div>
            <Processing v-if="processing" />
            <v-row>
              <v-col cols="12">
                <ArticleShowCard
                  :article="article"
                  :likers="likers"
                  @article-delete="onArticleDelete"
                />
              </v-col>
              <v-col cols="12">
                <BaseTitleCard class="mt-3" title="コメント一覧">
                  <div class="pa-5">
                    <article v-if="articleComments != null && articleComments.length === 0">
                      <v-card-text>この記事にコメントはありません。</v-card-text>
                      <v-divider class="my-4" />
                    </article>
                    <Comment v-for="articleComment in articleComments" :key="articleComment.id" :article-comment="articleComment" />
                    <CommentArea :article="article" />
                  </div>
                </BaseTitleCard>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </template>
    <template #right>
      <v-card-text>wow</v-card-text>
    </template>
  </TwoColumnContainer>
</template>

<script>
export default {
  props: {
    errors: {
      type: Object,
      default: undefined
    },
    processing: {
      type: Boolean,
      default: false
    },
    article: {
      type: Object,
      default: null
    },
    articleComments: {
      type: Array,
      default: () => []
    },
    likers: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  methods: {
    onArticleDelete (value) {
      this.$emit('article-delete', value)
    }
  }
}
</script>
