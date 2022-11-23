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
        <div class="text-center">
          <OrangeBtn
            id="user_update_btn"
            :disabled="invalid || processing"
            @click="onUserUpdate"
          >
            変更
          </OrangeBtn>
        </div>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver } from 'vee-validate'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import PasswordConfirmationTextField from '~/components/organisms/textFields/PasswordConfirmationTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'UserPasswordForm',

  components: {
    ValidationObserver,
    TheProcessing,
    PasswordTextField,
    PasswordConfirmationTextField,
    OrangeBtn
  },

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
