<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-5">
            <GenreImageFileInput
              v-model="image"
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
        <div>
          <RedBtn
            id="genre_create_btn"
            :disabled="invalid || processing"
            @click="onGenreCreate"
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
import GenreImageFileInput from '~/components/organisms/fileInputs/GenreImageFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'GenreNewForm',

  components: {
    ValidationObserver,
    TheProcessing,
    GenreImageFileInput,
    BaseTextField,
    RedBtn
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
      name: ''
    }
  },
  methods: {
    onGenreCreate () {
      const genreInfo = {
        image: this.image,
        name: this.name
      }
      this.$emit('genre-create', genreInfo)
    }
  }
}
</script>
