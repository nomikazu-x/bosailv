<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <EmailTextField
          v-model="email"
        />
        <PasswordTextField
          v-model="currentPassword"
          label="現在のパスワード"
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
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'

export default {
  name: 'UserEmailForm',

  components: {
    ValidationObserver,
    TheProcessing,
    EmailTextField,
    PasswordTextField,
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
      email: '',
      currentPassword: ''
    }
  },

  created () {
    this.email = this.email || this.user.email
  },

  methods: {
    onUserUpdate () {
      const userInfo = {
        email: this.email,
        current_password: this.currentPassword
      }
      this.$emit('user-update', userInfo)
    }
  }
}
</script>
