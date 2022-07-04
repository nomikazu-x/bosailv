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
export default {
  name: 'PasswordResetConfirmForm',
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
