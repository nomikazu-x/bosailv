<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
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
              v-model="title"
              title="title"
              label="タイトル"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="summary"
              title="summary"
              label="概要"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="body"
              title="body"
              label="本文"
            />
          </v-sheet>
        </v-col>
        <div class="text-center">
          <RedBtn
            id="task_update_btn"
            :disabled="invalid || processing"
            @click="onTaskUpdate"
          >
            作成
          </RedBtn>
          <DeleteConfirmDialog title="防災タスク削除" @click="onTaskDelete" />
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
import DeleteConfirmDialog from '~/components/organisms/dialogs/DeleteConfirmDialog.vue'

export default {
  name: 'TaskEditForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseImageFileInput,
    BaseTextField,
    BaseTextarea,
    RedBtn,
    DeleteConfirmDialog
  },

  props: {
    errors: {
      type: Object,
      default: undefined
    },
    task: {
      type: Object,
      default: null
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
  computed: {
    getImage () {
      return (this.task && this.task.image_url.xlarge) || undefined
    }
  },
  created () {
    this.title = this.title || this.task.title
    this.summary = this.summary || this.task.summary
    this.body = this.body || this.task.body
  },
  methods: {
    onTaskUpdate () {
      const taskInfo = {
        title: this.title,
        summary: this.summary,
        body: this.body,
        image: this.image
      }
      this.$emit('task-update', taskInfo)
    },
    onTaskDelete () {
      this.$emit('task-delete')
    }
  }
}
</script>
