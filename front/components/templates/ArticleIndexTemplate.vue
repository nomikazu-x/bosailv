<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <v-container v-if="!loading">
      <Processing v-if="processing" />
      <v-card-title>記事一覧</v-card-title>
      <v-row>
        <v-col cols="12">
          <ArticleLists :articles="articles" />

          <div v-if="info != null && info.total_pages > 1">
            <v-pagination
              id="pagination2"
              v-model="page"
              :length="info.total_pages"
              @input="onPagination"
            />
          </div>
        </v-col>
      </v-row>
    </v-container>
  </OneColumnContainer>
</template>

<script>
export default {
  props: {
    info: {
      type: Object,
      default: null
    },
    articles: {
      type: Array,
      default: () => []
    },
    processing: {
      type: Boolean,
      default: false
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
  data () {
    return {
      page: 1
    }
  },
  methods: {
    onPagination () {
      return this.$emit('pagination', this.page)
    }
  }
}
</script>
