<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-4 pa-2" height="80">
            <BaseSelect
              v-model="selectLabel"
              :items="labelItems"
              item-text="name"
              item-value="label"
              name="infomationLabel"
              label="ラベル"
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
          <v-sheet outlined height="60">
            <BaseDateTimePicker
              v-model="startedAt"
              name="started_at"
              title="開始時間"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined height="60">
            <BaseDateTimePicker
              v-model="endedAt"
              name="ended_at"
              title="終了時間"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined height="60">
            <BaseDateTimePicker
              v-model="forceStartedAt"
              name="force_started_at"
              title="大切なお知らせ開始時間"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined height="60">
            <BaseDateTimePicker
              v-model="forceEndedAt"
              name="force_ended_at"
              title="大切なお知らせ終了時間"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="150">
            <BaseTextarea
              v-model="summary"
              name="summary"
              label="概要"
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
        <div>
          <RedBtn
            id="infomation_create_btn"
            :disabled="invalid || processing"
            @click="onInfomationCreate"
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
import BaseSelect from '~/components/molecules/select/BaseSelect.vue'
import BaseDateTimePicker from '~/components/molecules/picker/BaseDateTimePicker.vue'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import Editor from '~/components/organisms/editor/Editor.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'InfomationNewForm',

  components: {
    ValidationObserver,
    BaseSelect,
    BaseDateTimePicker,
    TheProcessing,
    BaseTextField,
    BaseTextarea,
    Editor,
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
      labelItems: [
        { name: 'なし', label: 'Not' },
        { name: 'メンテナンス', label: 'Maintenance' },
        { name: '緊急', label: 'Hindrance' },
        { name: 'その他', label: 'Other' }
      ],
      selectLabel: null,
      title: '',
      summary: '',
      body: '',
      startedAt: null,
      endedAt: null,
      forceStartedAt: null,
      forceEndedAt: null
    }
  },
  methods: {
    onInfomationCreate () {
      const infomationInfo = {
        title: this.title,
        label: this.selectLabel,
        summary: this.summary,
        body: this.body,
        startedAt: this.startedAt,
        endedAt: this.endedAt,
        forceStartedAt: this.forceStartedAt,
        forceEndedAt: this.forceEndedAt
      }
      console.log(infomationInfo)
      this.$emit('infomation-create', infomationInfo)
    }
  }
}
</script>
