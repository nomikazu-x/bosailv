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
      <v-row v-if="!loading" justify="center">
        <v-col cols="12">
          <BaseTitleCard title="記事検索">
            <v-row class="pa-5">
              <v-col cols="12">
                <ValidationProvider v-slot="{ errors }" name="keyword" rules="required">
                  <v-text-field
                    v-model="keyword"
                    label="キーワード検索"
                    color="#3c3c3c"
                    prepend-icon="mdi-magnify"
                    :error-messages="errors"
                  />
                </ValidationProvider>
              </v-col>
              <v-col cols="12">
                <GenresCheckbox v-model="selectedGenres" />
              </v-col>
              <v-col cols="12">
                <div class="text-center mt-5">
                  <RedBtn @click="onSearchArticlePagination">検索</RedBtn>
                </div>
              </v-col>
            </v-row>
            <v-row justify="center">
              <v-col cols="12">
                <v-card-title v-if="info">検索結果：{{ info.total_count }}件</v-card-title>
              </v-col>
              <v-col cols="12">
                <TabArticleList
                  :articles="articles"
                  :info="info"
                  :processing="processing"
                  @pagination="onSearchArticlePagination"
                />
              </v-col>
            </v-row>
          </BaseTitleCard>
        </v-col>
      </v-row>
    </template>

    <template #right>
      <DefaultRightColumnTemplate :loading="loading" />
    </template>
  </TwoColumnContainer>
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
      keyword: '',
      selectedGenres: []
    }
  },
  methods: {
    onSearchArticlePagination (value) {
      const searchInfo = {
        page: value,
        keyword: this.keyword,
        selectedGenres: this.selectedGenres
      }
      return this.$emit('search-article-pagination', searchInfo)
    }
  }
}
</script>
