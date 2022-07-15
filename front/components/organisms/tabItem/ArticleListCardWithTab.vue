<template>
  <div>
    <TheProcessing v-if="processing" />
    <v-card tile>
      <v-card-title v-if="articles != null && articles.length === 0" class="ml-1">記事はありません。</v-card-title>
      <div v-for="article in articles" :key="article.id">
        <ArticleListCardText
          :article="article"
        />
      </div>

      <ThePagination
        class="mt-5"
        :info="info"
        @pagination="onPagination"
      />
    </v-card>
  </div>
</template>

<script>
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import ArticleListCardText from '~/components/organisms/cardText/ArticleListCardText.vue'
import ThePagination from '~/components/organisms/pagination/ThePagination.vue'

export default {
  name: 'ArticleListCardWithTab',

  components: {
    TheProcessing,
    ArticleListCardText,
    ThePagination
  },

  props: {
    articles: {
      type: Array,
      default: () => []
    },
    info: {
      type: Object,
      default: null
    },
    processing: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onPagination (value) {
      return this.$emit('pagination', value)
    }
  }
}
</script>
