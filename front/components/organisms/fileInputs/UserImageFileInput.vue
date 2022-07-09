<template>
  <ValidationObserver v-slot="{ invalid }" ref="observer">
    <TheProcessing v-if="processing" />
    <v-form>
      <v-card-text>
        <v-avatar size="256px">
          <v-img :src="$auth.user.image_url.xlarge" />
        </v-avatar>
        <ValidationProvider v-slot="{ errors }" name="image" rules="size_20MB:20480">
          <v-file-input
            v-model="image"
            accept="image/jpeg,image/gif,image/png"
            label="画像ファイル"
            prepend-icon="mdi-camera"
            show-size
            :error-messages="errors"
          />
        </ValidationProvider>
        <RedBtn id="user_image_update_btn" color="primary" :disabled="invalid || image === null || processing" @click="onUserImageUpdate">アップロード</RedBtn>
        <v-dialog transition="dialog-top-transition" max-width="600px">
          <template #activator="{ on, attrs }">
            <v-btn id="user_image_delete_btn" color="secondary" :disabled="!$auth.user.upload_image || processing" v-bind="attrs" v-on="on">画像削除</v-btn>
          </template>
          <template #default="dialog">
            <v-card id="user_image_delete_dialog">
              <v-toolbar color="secondary" dark>画像削除</v-toolbar>
              <v-card-text>
                <div class="text-h6 pa-6">本当に削除しますか？</div>
              </v-card-text>
              <v-card-actions class="justify-end">
                <v-btn id="user_image_delete_no_btn" color="secondary" @click="dialog.value = false">いいえ</v-btn>
                <RedBtn id="user_image_delete_yes_btn" color="primary" @click="dialog.value = false; onUserImageDelete()">はい</RedBtn>
              </v-card-actions>
            </v-card>
          </template>
        </v-dialog>
      </v-card-text>
    </v-form>
  </ValidationObserver>
</template>

<script>
import { ValidationObserver, ValidationProvider, extend, configure, localize } from 'vee-validate'
import { size } from 'vee-validate/dist/rules'
import TheProcessing from '~/components/organisms/application/TheProcessing.vue'
import RedBtn from '~/components/atoms/btns/RedBtn.vue'

extend('size_20MB', size)
configure({ generateMessage: localize('ja', require('~/locales/validate.ja.js')) })

export default {
  name: 'UserImageFileInput',

  components: {
    ValidationObserver,
    ValidationProvider,
    TheProcessing,
    RedBtn
  },

  props: {
    processing: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      image: null
    }
  },

  methods: {
    onUserImageUpdate () {
      this.$emit('user-image-update', this.image)
      this.image = null
    },
    onUserImageDelete () {
      this.$emit('user-image-delete')
      this.image = null
    }
  }
}
</script>
