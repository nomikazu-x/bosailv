<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="mt-4 pa-2" height="60">
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
import BaseDateTimePicker from '~/components/molecules/picker/BaseDateTimePicker.vue'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseTextField from '~/components/molecules/textFields/BaseTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'InfomationNewForm',

  components: {
    ValidationObserver,
    BaseDateTimePicker,
    TheProcessing,
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
      title: '',
      startedAt: null
    }
  },
  methods: {
    onInfomationCreate () {
      const infomationInfo = {
        title: this.title,
        startedAt: this.startedAt
      }
      console.log(infomationInfo)
      this.$emit('infomation-create', infomationInfo)
    }
  }
}
</script>
