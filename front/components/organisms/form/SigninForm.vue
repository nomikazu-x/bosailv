<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <v-form autocomplete="on" @submit.prevent="onSubmit">
      <EmailTextField v-model="email" />

      <PasswordTextField v-model="password" />

      <div class="text-center mt-4">
        <OrangeBtn type="submit" :disabled="invalid || processing">
          ログイン
        </OrangeBtn>
      </div>
    </v-form>
  </ValidationObserver>
</template>

<script>
import EmailTextField from '~/components/organisms/textFields/EmailTextField'
import PasswordTextField from '~/components/organisms/textFields/PasswordTextField'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn'

export default {
  components: {
    EmailTextField,
    PasswordTextField,
    OrangeBtn
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
      this.validate()
      const userInfo = {
        email: this.email,
        password: this.password
      }
      this.$emit('signin', userInfo)
    },
    validate () {
      this.$refs.observer.validate()
    }
  }
}
</script>
