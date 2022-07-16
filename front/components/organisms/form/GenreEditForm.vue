<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-5">
            <GenreImageFileInput
              v-model="image"
              :old-src="getImage"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="60">
            <ArticleTitleTextField
              v-model="name"
            />
          </v-sheet>
        </v-col>
        <div class="text-center">
          <RedBtn
            id="genre_update_btn"
            :disabled="invalid || processing"
            @click="onGenreUpdate"
          >
            作成
          </RedBtn>
          <DeleteConfirmDialog title="ジャンル削除" @click="onGenreDelete" />
        </div>
      </v-row>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import Application from '~/plugins/application.js'
import GenreImageFileInput from '~/components/organisms/fileInputs/GenreImageFileInput.vue'
import ArticleTitleTextField from '~/components/organisms/textFields/ArticleTitleTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'GenreEditForm',

  components: {
    ValidationObserver,
    GenreImageFileInput,
    ArticleTitleTextField,
    RedBtn,
    DeleteConfirmDialog
  },

  mixins: [Application],

  props: {
    errors: {
      type: Object,
      default: undefined
    },
    genre: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      image: null,
      name: ''
    }
  },
  computed: {
    getImage () {
      return (this.genre && this.genre.image_url.xlarge) || undefined
    }
  },
  created () {
    this.name = this.name || (this.genre && this.genre.name)
    this.processing = false
  },
  methods: {
    onGenreUpdate () {
      const genreInfo = {
        image: this.image,
        name: this.name
      }
      this.$emit('genre-update', genreInfo)
    },
    async onGenreDelete () {
      this.processing = true

      await this.$axios.post(this.$config.apiBaseURL + this.$config.genreDeleteUrl.replace('_id', this.$route.params.id))
        .then((response) => {
          if (response.data == null) {
            this.$toasted.error(this.$t('system.error'))
          } else {
            this.$toasted.error(response.data.alert)
            this.$toasted.info(response.data.notice)
            return this.$router.push({ path: '/admin/genres' })
          }
        },
        (error) => {
          if (error.response == null) {
            this.$toasted.error(this.$t('network.failure'))
          } else if (error.response.status === 401) {
            return this.signOut()
          } else if (error.response.data == null) {
            this.$toasted.error(this.$t('network.error'))
          } else {
            this.$toasted.error(error.response.data.alert)
            this.$toasted.info(error.response.data.notice)
          }
        })

      this.processing = false
    }
  }
}
</script>
