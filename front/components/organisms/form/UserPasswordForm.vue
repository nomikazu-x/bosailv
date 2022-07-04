<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <PasswordTextField
          v-model="currentPassword"
          label="現在のパスワード"
        />
        <PasswordConfirmationTextField
          v-model="password"
          :password-confirmation.sync="passwordConfirmation"
        />
        <RedBtn
          id="user_update_btn"
          :disabled="invalid || processing"
          @click="onUserUpdate"
        >
          変更
        </RedBtn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  name: 'UserPasswordForm',
  props: {
    processing: {
      type: Boolean,
      default: false
    },
    user: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      currentPassword: '',
      password: '',
      passwordConfirmation: ''
    }
  },

  methods: {
    onUserUpdate () {
      const userInfo = {
        current_password: this.currentPassword,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      }
      this.$emit('user-update', userInfo)
    }
  }
}
</script>
