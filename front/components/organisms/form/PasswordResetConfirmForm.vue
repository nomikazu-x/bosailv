<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="on">
      <PasswordConfirmationTextField
        v-model="password"
        :password-confirmation.sync="passwordConfirmation"
      />

      <div class="d-flex justify-end">
        <OrangeBtn
          type="submit"
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          送信
        </OrangeBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>export default {
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
