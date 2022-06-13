<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col class="py-0 mr-sm-4" cols="12" sm="8" md="8">
          <ArticleThumbnailFileInput
            v-model="thumbnail"
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
            id="article_create_btn"
            class="post-btn"
            :disabled="invalid || processing"
            @click="onArticleCreate"
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
  props: {
    errors: {
      type: Object,
      default: undefined
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
      thumbnail: null,
      title: '',
      content: '',
      selectedGenres: []
    }
  },
  methods: {
    onArticleCreate () {
      const articleInfo = {
        thumbnail: this.thumbnail,
        title: this.title,
        content: this.content,
        selectedGenres: this.selectedGenres
      }
      this.$emit('article-create', articleInfo)
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
