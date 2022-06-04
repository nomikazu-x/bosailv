<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <Processing v-if="processing" />
    <v-form autocomplete="off">
      <v-card-text>
        <EmailTextField
          v-model="email"
        />
        <PasswordTextField
          v-model="currentPassword"
          label="現在のパスワード"
        />
        <OrangeBtn
          id="user_update_btn"
          :disabled="invalid || processing"
          @click="onUserUpdate"
        >
          変更
        </OrangeBtn>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
export default {
  name: 'InfoEdit',
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
