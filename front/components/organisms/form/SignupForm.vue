<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="on">
      <NameTextField
        v-model="name"
      />

      <EmailTextField
        v-model="email"
      />

      <PasswordConfirmationTextField
        v-model="password"
        :password-confirmation.sync="passwordConfirmation"
      />

      <div class="text-center mt-4">
        <OrangeBtn
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          新規登録
        </OrangeBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
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
      name: '',
      email: '',
      password: '',
      passwordConfirmation: ''
    }
  },
  methods: {
    onSubmit () {
      const userInfo = {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      }
      this.$emit('signup', userInfo)
    }
  }
}
</script>
