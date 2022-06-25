<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
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
      this.$emit('signin', userInfo)
    }
  }
}
</script>
