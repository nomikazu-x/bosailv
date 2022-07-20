<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-5">
            <ArticleThumbnailFileInput
              v-if="getImage"
              v-model="thumbnail"
              :old-src="getImage"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="60">
            <BaseTextField
              v-model="title"
              name="title"
              label="タイトル"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="300">
            <GenresCheckbox
              v-model="selectedGenres"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet height="600">
            <Editor
              v-model="content"
            />
          </v-sheet>
        </v-col>
        <div class="text-right">
          <RedBtn
            id="article_update_btn"
            class="post-btn"
            :disabled="invalid || processing"
            @click="onArticleUpdate"
          >
            作成
          </RedBtn>
        </div>
      </v-row>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import ArticleThumbnailFileInput from '~/components/organisms/fileInputs/ArticleThumbnailFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import GenresCheckbox from '~/components/organisms/checkbox/GenresCheckbox.vue'
import Editor from '~/components/organisms/editor/Editor.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'ArticleEditForm',

  components: {
    ValidationObserver,
    TheProcessing,
    ArticleThumbnailFileInput,
    BaseTextField,
    GenresCheckbox,
    Editor,
    RedBtn
  },

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
    this.selectedGenres = this.article.genres.forEach((value) => { this.selectedGenres.push(value.id) }) || this.selectedGenres
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
