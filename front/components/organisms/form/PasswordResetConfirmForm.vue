<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="on">
      <PasswordConfirmationTextField
        v-model="password"
        :password-confirmation.sync="passwordConfirmation"
      />

      <div class="d-flex justify-end">
        <RedBtn
          type="submit"
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          送信
        </RedBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import PasswordConfirmationTextField from '~/components/organisms/textFields/PasswordConfirmationTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'PasswordResetConfirmForm',

  components: {
    ValidationObserver,
    TheProcessing,
    PasswordConfirmationTextField,
    RedBtn
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
      this.$emit('submit', userInfo)
    }
  }
}
</script>
