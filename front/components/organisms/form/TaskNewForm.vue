<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseImageFileInput
              v-model="image"
              label="画像を選択してください。"
              name="image"
              rules="required|size_20MB:20480"
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
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="summary"
              name="summary"
              label="概要"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="body"
              name="body"
              label="本文"
            />
          </v-sheet>
        </v-col>
        <div>
          <RedBtn
            id="task_create_btn"
            :disabled="invalid || processing"
            @click="onTaskCreate"
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
import BaseImageFileInput from '~/components/molecules/fileInputs/BaseImageFileInput.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'InfomationNewForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseImageFileInput,
    BaseTextField,
    BaseTextarea,
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
      title: '',
      summary: '',
      body: '',
      image: null
    }
  },
  methods: {
    onTaskCreate () {
      const taskInfo = {
        title: this.title,
        summary: this.summary,
        body: this.body,
        image: this.image
      }
      this.$emit('task-create', taskInfo)
    }
  }
}
</script>
