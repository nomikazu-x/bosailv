<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="on">
      <EmailTextField
        v-model="email"
      />

      <div class="text-center mt-4">
        <OrangeBtn
          id="password_reset_btn"
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          送信
        </OrangeBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'PasswordResetForm',

  components: {
    ValidationObserver,
    TheProcessing,
    EmailTextField,
    OrangeBtn
  },

  props: {
    processing: {
      type: Boolean,
      default: false
    },
    errors: {
      type: Object,
      default: undefined
    }
  },
  data () {
    return {
      email: ''
    }
  },
  methods: {
    onSubmit () {
      this.$emit('password-new', this.email)
    }
  }
}
</script>
