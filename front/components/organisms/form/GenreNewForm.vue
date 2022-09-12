<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-5">
            <BaseImageFileInput
              v-model="image"
              name="image"
              label="画像を選択してください。"
              rules="required|size_20MB:20480"
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
        <div>
          <OrangeBtn
            id="genre_create_btn"
            :disabled="invalid || processing"
            @click="onGenreCreate"
          >
            作成
          </OrangeBtn>
        </div>
      </v-row>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseImageFileInput from '~/components/molecules/fileInputs/BaseImageFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'GenreNewForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseImageFileInput,
    BaseTextField,
    BaseTextarea,
    OrangeBtn
  },

  props: {
    errors: {
      type: Object,
      default: undefined
    },
    processing: {
      type: Boolean,
      default: false
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
  methods: {
    onGenreCreate () {
      const genreInfo = {
        image: this.image,
        name: this.name,
        icon: this.icon,
        description: this.description
      }
      this.$emit('genre-create', genreInfo)
    }
  }
}
</script>
