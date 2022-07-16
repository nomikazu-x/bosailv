<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="pa-2" height="60">
            <BaseTextField
              v-model="title"
              name="title"
              label="タイトル"
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
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import BaseTextField from '~/components/organisms/textFields/BaseTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'InfomationNewForm',

  components: {
    ValidationObserver,
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
        title: this.title
      }
      this.$emit('infomation-create', infomationInfo)
    }
  }
}
</script>
