<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form autocomplete="on">
      <EmailTextField
        v-model="email"
      />

      <PasswordTextField
        v-model="password"
      />

      <div class="text-center mt-4">
        <RedBtn
          type="submit"
          :disabled="invalid || processing"
          @click="onSubmit"
        >
          ログイン
        </RedBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import EmailTextField from '~/components/organisms/textFields/EmailTextField.vue'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

export default {
  name: 'SigninForm',

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
    errors: {
      type: Object,
      default: undefined
    }
  },
  data () {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    onSubmit () {
      const userInfo = {
        email: this.email,
        password: this.password
      }
      this.$emit('sign-in', userInfo)
    }
  }
}
</script>
