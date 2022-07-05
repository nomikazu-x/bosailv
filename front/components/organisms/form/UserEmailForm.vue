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
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'UserEmailForm',

  components: {
    TheProcessing,
    EmailTextField,
    PasswordTextField,
    RedBtn
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
