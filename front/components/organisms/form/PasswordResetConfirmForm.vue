<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <v-form autocomplete="on" @submit.prevent="onSubmit">
      <PasswordConfirmationTextField v-model="password" :password-confirmation.sync="passwordConfirmation" />

      <div class="d-flex justify-end">
        <OrangeBtn type="submit" :disabled="invalid || processing">
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
      this.validate()
      const userInfo = {
        password: this.password,
        password_confirmation: this.passwordConfirmation
      }
      this.$emit('submit', userInfo)
    },
    validate () {
      this.$refs.observer.validate()
    }
  }
}
</script>
