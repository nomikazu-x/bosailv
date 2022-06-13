<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col class="py-0 mr-sm-4" cols="12" sm="8" md="8">
          <ArticleThumbnailFileInput
            v-if="getImage"
            v-model="thumbnail"
            :old-src="getImage"
          />
        </v-col>
        <v-col class="py-0 mr-sm-4" cols="12" sm="8" md="8">
          <ArticleTitleTextField
            v-model="title"
          />
        </v-col>
        <v-col class="mb-16" cols="12" sm="10" md="10">
          <GenresCheckbox
            v-model="selectedGenres"
          />
        </v-col>
        <v-col class="py-0 mr-sm-4" cols="12" sm="8" md="8">
          <Editor
            v-model="content"
          />
        </v-col>
        <div class="text-right">
          <OrangeBtn
            id="article_update_btn"
            class="post-btn"
            :disabled="invalid || processing"
            @click="onArticleUpdate"
          >
            作成
          </OrangeBtn>
        </div>
      </v-row>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  name: 'InfoEdit',
  props: {
    processing: {
      type: Boolean,
      default: false
    },
    article: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      thumbnail: null,
      title: '',
      content: '',
      selectedGenres: []
    }
  },
  computed: {
    getImage () {
      return (this.article && this.article.thumbnail_url.xlarge) || undefined
    }
  },
  created () {
    this.title = this.title || this.article.title
    this.content = this.content || this.article.content
    this.article.genres.forEach((value) => {
      this.selectedGenres.push(value.id)
    })
  },
  methods: {
    onArticleUpdate () {
      const articleInfo = {
        thumbnail: this.thumbnail,
        title: this.title,
        content: this.content,
        selectedGenres: this.selectedGenres
      }
      this.$emit('article-update', articleInfo)
    }
  }
}
</script>

<style lang="scss" scoped>
.post-btn {
  position: fixed;
  bottom: 5vh;
  right: 5vw;
}
</style>
