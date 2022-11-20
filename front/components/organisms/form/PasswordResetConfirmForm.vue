<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="on">
      <PasswordConfirmationTextField
        v-model="password"
        :password-confirmation.sync="passwordConfirmation"
      />

      <div class="text-center mt-4">
        <OrangeBtn
          id="password_reset_confirm_btn"
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
import PasswordConfirmationTextField from '~/components/organisms/textFields/PasswordConfirmationTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'PasswordResetConfirmForm',

  components: {
    ValidationObserver,
    TheProcessing,
    PasswordConfirmationTextField,
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
      password: '',
      passwordConfirmation: ''
    }
  },
  methods: {
    onSubmit () {
      const userInfo = {
        password: this.password,
        password_confirmation: this.passwordConfirmation
      }
      this.$emit('password-update', userInfo)
    }
  }
}
</script>
