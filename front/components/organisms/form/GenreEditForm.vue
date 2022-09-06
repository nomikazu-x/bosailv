<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-5">
            <BaseImageFileInput
              v-model="image"
              :old-src="getImage"
              label="画像を選択してください。"
              title="image"
              rules="size_20MB:20480"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="60">
            <BaseTextField
              v-model="name"
              name="name"
              label="ジャンル名"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="60">
            <BaseTextField
              v-model="icon"
              name="icon"
              label="アイコン"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="description"
              name="description"
              label="説明文"
            />
          </v-sheet>
        </v-col>
        <div class="text-center">
          <OrangeBtn
            id="genre_update_btn"
            :disabled="invalid || processing"
            @click="onGenreUpdate"
          >
            作成
          </OrangeBtn>
          <DeleteConfirmDialog title="ジャンル削除" @click="onGenreDelete" />
        </div>
      </v-row>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import Application from '~/plugins/application.js'
import BaseImageFileInput from '~/components/molecules/fileInputs/BaseImageFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'GenreEditForm',

  components: {
    ValidationObserver,
    BaseImageFileInput,
    BaseTextField,
    BaseTextarea,
    OrangeBtn,
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
      name: '',
      icon: '',
      description: ''
    }
  },
  computed: {
    getImage () {
      return (this.genre && this.genre.image_url.xlarge) || undefined
    }
  },
  created () {
    this.name = this.name || this.genre.name
    this.icon = this.icon || this.genre.icon
    this.description = this.description || this.genre.description
    this.processing = false
  },
  methods: {
    onGenreUpdate () {
      const genreInfo = {
        image: this.image,
        name: this.name,
        icon: this.icon,
        description: this.description
      }
      this.$emit('genre-update', genreInfo)
    },
    onGenreDelete () {
      this.$emit('genre-delete')
    }
  }
}
</script>
