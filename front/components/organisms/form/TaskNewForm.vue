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
              rules="required|max:20"
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
              v-model="summary"
              name="summary"
              label="概要"
              rules="required|max:30"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet height="600">
            <Editor
              v-model="body"
              name="body"
            />
          </v-sheet>
        </v-col>
        <div class="text-center">
          <OrangeBtn
            id="task_create_btn"
            :disabled="invalid || processing"
            @click="onTaskCreate"
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
import Editor from '~/components/organisms/editor/Editor.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'TaskNewForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseImageFileInput,
    BaseTextField,
    BaseTextarea,
    Editor,
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
      title: '',
      summary: '',
      body: '',
      image: null,
      icon: ''
    }
  },
  methods: {
    onTaskCreate () {
      const taskInfo = {
        title: this.title,
        summary: this.summary,
        body: this.body,
        image: this.image,
        icon: this.icon
      }
      this.$emit('task-create', taskInfo)
    }
  }
}
</script>
