<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-row justify="center">
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="contactMeansMemo"
              title="contact_means_memo"
              label="非常時の連絡方法に関するメモ"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="refugeMemo"
              title="refuge_memo"
              label="避難場所のルートに関するメモ"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="familyRoleMemo"
              title="family_role_memo"
              label="災害直後の家族の役割分担に関するメモ"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="emergencyMeasureMemo"
              title="emergency_measure_memo"
              label="応急処置に関するメモ"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-sheet outlined class="pa-2">
            <BaseTextarea
              v-model="leaveHomeMemo"
              title="leave_home_memo"
              label="家を離れるときのメモ"
              rules="required"
            />
          </v-sheet>
        </v-col>
        <div class="text-center">
          <OrangeBtn
            id="task_update_btn"
            :disabled="invalid || processing"
            @click="onFamilyRuleUpdate"
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
import BaseTextarea from '~/components/molecules/textarea/BaseTextarea.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'TaskEditForm',

  components: {
    ValidationObserver,
    TheProcessing,
    BaseTextarea,
    OrangeBtn
  },

  props: {
    errors: {
      type: Object,
      default: undefined
    },
    familyRule: {
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
      contactMeansMemo: '',
      refugeMemo: '',
      familyRoleMemo: '',
      emergencyMeasureMemo: '',
      leaveHomeMemo: ''
    }
  },
  created () {
    this.contactMeansMemo = this.contactMeansMemo || this.familyRule.contact_means_memo
    this.refugeMemo = this.refugeMemo || this.familyRule.refuge_memo
    this.familyRoleMemo = this.familyRoleMemo || this.familyRule.family_role_memo
    this.emergencyMeasureMemo = this.emergencyMeasureMemo || this.familyRule.emergency_measure_memo
    this.leaveHomeMemo = this.leaveHomeMemo || this.familyRule.leave_home_memo
  },
  methods: {
    onFamilyRuleUpdate () {
      const familyRuleInfo = {
        contact_means_memo: this.contactMeansMemo,
        refuge_memo: this.refugeMemo,
        family_role_memo: this.familyRoleMemo,
        emergency_measure_memo: this.emergencyMeasureMemo,
        leave_home_memo: this.leaveHomeMemo
      }
      this.$emit('family-rule-update', familyRuleInfo)
    }
  }
}
</script>
